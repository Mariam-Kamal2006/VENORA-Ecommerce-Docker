<?php

session_set_cookie_params([
    'httponly' => true,
    'samesite' => 'Lax',
    'path' => '/'
]);

session_start();

require_once __DIR__ . '/../config/db.php';

// التأكد أن المستخدم عامل Login
$user = $_SESSION['user'] ?? null;

if (!$user || empty($user['id'])) {
    respond(['error' => 'Please log in first.'], 401);
}

$userId = (int)$user['id'];

$action = $_GET['action'] ?? '';
$in = json_decode(file_get_contents('php://input'), true) ?: [];

// الحصول على Cart الخاصة بالمستخدم أو إنشاؤها
function getCartId($pdo, $userId) {
    $stmt = $pdo->prepare("
        INSERT INTO carts (user_id)
        VALUES (?)
        ON DUPLICATE KEY UPDATE cart_id = LAST_INSERT_ID(cart_id)
    ");

    $stmt->execute([$userId]);

    return (int)$pdo->lastInsertId();
}

// ملخص السلة
if ($action === 'summary') {
    $cartId = getCartId($pdo, $userId);

    $stmt = $pdo->prepare("
        SELECT
            COALESCE(SUM(ci.quantity), 0) AS count,
            COALESCE(SUM(ci.quantity * p.price), 0) AS total
        FROM cartitems ci
        JOIN products p ON p.product_id = ci.product_id
        WHERE ci.cart_id = ?
    ");

    $stmt->execute([$cartId]);

    respond($stmt->fetch());
}

// عرض منتجات السلة
if ($action === 'list') {
    $cartId = getCartId($pdo, $userId);

    $stmt = $pdo->prepare("
        SELECT
            ci.product_id AS id,
            p.product_name AS name,
            p.price,
            p.image_url AS image,
            ci.quantity AS qty
        FROM cartitems ci
        JOIN products p ON p.product_id = ci.product_id
        WHERE ci.cart_id = ?
    ");

    $stmt->execute([$cartId]);

    respond(['items' => $stmt->fetchAll()]);
}

// باقي العمليات تحتاج POST
if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    respond(['error' => 'POST required.'], 405);
}

$cartId = getCartId($pdo, $userId);

// إضافة منتج
if ($action === 'add') {
    $productId = (int)($in['product_id'] ?? 0);
    $quantity = (int)($in['quantity'] ?? 1);

    if ($productId <= 0 || $quantity <= 0) {
        respond(['error' => 'Invalid product or quantity.'], 422);
    }

    // نتأكد أن المنتج موجود ونشط
    $stmt = $pdo->prepare("
        SELECT product_id
        FROM products
        WHERE product_id = ? AND is_active = 1
    ");

    $stmt->execute([$productId]);

    if (!$stmt->fetch()) {
        respond(['error' => 'Product not found.'], 404);
    }

    // هل المنتج موجود بالفعل في السلة؟
    $stmt = $pdo->prepare("
        SELECT cart_item_id, quantity
        FROM cartitems
        WHERE cart_id = ? AND product_id = ?
        LIMIT 1
    ");

    $stmt->execute([$cartId, $productId]);
    $item = $stmt->fetch();

    if ($item) {
        $stmt = $pdo->prepare("
            UPDATE cartitems
            SET quantity = quantity + ?
            WHERE cart_item_id = ?
        ");

        $stmt->execute([$quantity, $item['cart_item_id']]);
    } else {
        $stmt = $pdo->prepare("
            INSERT INTO cartitems (cart_id, product_id, quantity)
            VALUES (?, ?, ?)
        ");

        $stmt->execute([$cartId, $productId, $quantity]);
    }

    respond(['ok' => true, 'message' => 'Product added to cart.']);
}

// تعديل كمية منتج
if ($action === 'update') {
    $productId = (int)($in['product_id'] ?? 0);
    $quantity = (int)($in['quantity'] ?? 0);

    if ($productId <= 0 || $quantity < 0) {
        respond(['error' => 'Invalid product or quantity.'], 422);
    }

    if ($quantity === 0) {
        $stmt = $pdo->prepare("
            DELETE FROM cartitems
            WHERE cart_id = ? AND product_id = ?
        ");
        $stmt->execute([$cartId, $productId]);
    } else {
        $stmt = $pdo->prepare("
            UPDATE cartitems
            SET quantity = ?
            WHERE cart_id = ? AND product_id = ?
        ");
        $stmt->execute([$quantity, $cartId, $productId]);
    }

    respond(['ok' => true]);
}

// حذف منتج
if ($action === 'remove') {
    $productId = (int)($in['product_id'] ?? 0);

    $stmt = $pdo->prepare("
        DELETE FROM cartitems
        WHERE cart_id = ? AND product_id = ?
    ");

    $stmt->execute([$cartId, $productId]);

    respond(['ok' => true]);
}

// تفريغ السلة
if ($action === 'clear') {
    $stmt = $pdo->prepare("
        DELETE FROM cartitems
        WHERE cart_id = ?
    ");

    $stmt->execute([$cartId]);

    respond(['ok' => true]);
}

respond(['error' => 'Unknown action.'], 400);
