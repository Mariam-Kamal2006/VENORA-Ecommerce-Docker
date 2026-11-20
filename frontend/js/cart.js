
/**
 * VENORA Cart – MySQL Database
 * Products are loaded from backend/api/cart.php
 */

const CART_API = 'api/cart.php';
const AUTH_API = 'api/auth.php';
const ORDERS_API = 'api/orders.php';

const NOTES_KEY = 'venora_cart_notes';

let cartItems = [];

/* ===== API HELPER ===== */
async function apiRequest(url, options = {}) {
  const response = await fetch(url, {
    ...options,
    credentials: 'include',
    headers: {
      ...(options.body ? { 'Content-Type': 'application/json' } : {}),
      ...options.headers
    }
  });

  const text = await response.text();

  let data;

  try {
    data = JSON.parse(text);
  } catch (error) {
    console.error('Invalid server response:', text);
    throw new Error('Server returned HTML instead of JSON. Check PHP errors.');
  }

  if (!response.ok) {
    throw new Error(data.error || 'Request failed.');
  }

  return data;
}

/* ===== NOTES ===== */
function getNotes() {
  return localStorage.getItem(NOTES_KEY) || '';
}

function saveNotes(text) {
  localStorage.setItem(NOTES_KEY, text);
}

/* ===== PRICE FORMAT ===== */
function formatPrice(n) {
  return Number(n).toLocaleString(undefined, {
    maximumFractionDigits: 2
  }) + ' EGP';
}

/* ===== LOAD CART FROM MYSQL ===== */
async function loadCart() {
  try {
    const data = await apiRequest(`${CART_API}?action=list`);

    cartItems = Array.isArray(data.items) ? data.items : [];

    renderCart();

    return cartItems;

  } catch (error) {
    console.error('Could not load cart:', error);

    cartItems = [];
    renderCart();

    if (error.message.includes('Please log in')) {
      console.warn('User is not logged in.');
    } else {
      alert('Could not load your cart. Please try again.');
    }

    return [];
  }
}

/* ===== CART BADGE ===== */
function updateBadge() {
  const totalQty = cartItems.reduce(
    (sum, item) => sum + Number(item.qty),
    0
  );

  document.querySelectorAll('#cartBadge, .cart-badge').forEach(badge => {
    badge.textContent = totalQty;
    badge.style.display = totalQty > 0 ? 'grid' : 'none';
  });
}

/* ===== ESCAPE HTML ===== */
function escapeHTML(value) {
  return String(value ?? '').replace(/[&<>"']/g, char => ({
    '&': '&amp;',
    '<': '&lt;',
    '>': '&gt;',
    '"': '&quot;',
    "'": '&#039;'
  })[char]);
}

/* ===== RENDER CART ===== */
function renderCart() {
  const emptyEl = document.getElementById('cartEmpty');
  const panelEl = document.getElementById('cartPanel');
  const itemsEl = document.getElementById('cartItems');

  updateBadge();

  if (!emptyEl || !panelEl || !itemsEl) return;

  if (!cartItems.length) {
    emptyEl.hidden = false;
    panelEl.hidden = true;
    return;
  }

  emptyEl.hidden = true;
  panelEl.hidden = false;

  itemsEl.innerHTML = cartItems.map(item => {
    const id = Number(item.id);
    const name = escapeHTML(item.name);
    const image = escapeHTML(item.image || 'images/hero.jpeg');
    const price = Number(item.price);
    const qty = Number(item.qty);

    return `
      <div class="cart-item" data-id="${id}">

        <div class="cart-item-img">
          <img src="${image}"
               alt="${name}"
               onerror="this.src='images/hero.jpeg'">
        </div>

        <div class="cart-item-info">
          <h3 class="cart-item-name">${name}</h3>
          <p class="cart-item-price">
            ${formatPrice(price)} each
          </p>
        </div>

        <div class="cart-item-controls">
          <div class="qty-control">

            <button type="button"
                    class="qty-btn qty-minus"
                    aria-label="Decrease">−</button>

            <span class="qty-value">${qty}</span>

            <button type="button"
                    class="qty-btn qty-plus"
                    aria-label="Increase">+</button>

          </div>

          <button type="button"
                  class="remove-btn"
                  aria-label="Remove">×</button>
        </div>

        <div class="cart-item-line-total">
          ${formatPrice(price * qty)}
        </div>

      </div>
    `;
  }).join('');

  const subtotal = cartItems.reduce(
    (sum, item) =>
      sum + Number(item.price) * Number(item.qty),
    0
  );

  const subtotalEl = document.getElementById('cartSubtotal');
  const totalEl = document.getElementById('cartTotal');

  if (subtotalEl) subtotalEl.textContent = formatPrice(subtotal);
  if (totalEl) totalEl.textContent = formatPrice(subtotal);

  const notesEl = document.getElementById('cartNotes');

  if (notesEl && document.activeElement !== notesEl) {
    notesEl.value = getNotes();
  }

  bindItemEvents();
}

/* ===== ITEM EVENTS ===== */
function bindItemEvents() {
  document.querySelectorAll('.cart-item').forEach(row => {
    const id = row.dataset.id;

    row.querySelector('.qty-plus')?.addEventListener('click', () => {
      changeQty(id, 1);
    });

    row.querySelector('.qty-minus')?.addEventListener('click', () => {
      changeQty(id, -1);
    });

    row.querySelector('.remove-btn')?.addEventListener('click', () => {
      removeItem(id);
    });
  });
}

/* ===== UPDATE QUANTITY IN MYSQL ===== */
async function changeQty(id, delta) {
  const item = cartItems.find(
    item => String(item.id) === String(id)
  );

  if (!item) return;

  const newQty = Number(item.qty) + delta;

  try {
    await apiRequest(`${CART_API}?action=update`, {
      method: 'POST',
      body: JSON.stringify({
        product_id: Number(id),
        quantity: Math.max(0, newQty)
      })
    });

    await loadCart();

  } catch (error) {
    console.error('Could not update quantity:', error);
    alert(error.message);
  }
}

/* ===== REMOVE ITEM ===== */
async function removeItem(id) {
  try {
    await apiRequest(`${CART_API}?action=remove`, {
      method: 'POST',
      body: JSON.stringify({
        product_id: Number(id)
      })
    });

    await loadCart();

  } catch (error) {
    console.error('Could not remove item:', error);
    alert(error.message);
  }
}

/* ===== CLEAR CART ===== */
async function clearCart() {
  if (!confirm('Clear all items from your cart?')) return;

  try {
    await apiRequest(`${CART_API}?action=clear`, {
      method: 'POST',
      body: JSON.stringify({})
    });

    localStorage.removeItem(NOTES_KEY);

    cartItems = [];
    renderCart();

  } catch (error) {
    console.error('Could not clear cart:', error);
    alert(error.message);
  }
}

/* ===== PUBLIC CART API ===== */
window.VenoraCart = {
  async add(productId) {
    if (!productId) {
      console.error('Product ID is required.');
      return;
    }

    try {
      await apiRequest(`${CART_API}?action=add`, {
        method: 'POST',
        body: JSON.stringify({
          product_id: Number(productId),
          quantity: 1
        })
      });

      await loadCart();

      return true;

    } catch (error) {
      console.error('Could not add product:', error);
      alert(error.message);
      return false;
    }
  },

  get: () => [...cartItems],

  load: loadCart,

  clear: clearCart
};

/* ===== CHECKOUT ===== */
async function checkout() {
  if (!cartItems.length) return;

  try {
    const me = await apiRequest(`${AUTH_API}?action=me`);

    if (!me.user) {
      alert('Please log in first to place your order.');
      window.location.href = 'profile.html';
      return;
    }

    const data = await apiRequest(`${ORDERS_API}?action=create`, {
      method: 'POST',
      body: JSON.stringify({
        items: cartItems.map(item => ({
          id: Number(item.id),
          qty: Number(item.qty)
        }))
      })
    });

    await apiRequest(`${CART_API}?action=clear`, {
      method: 'POST',
      body: JSON.stringify({})
    });

    localStorage.removeItem(NOTES_KEY);

    cartItems = [];
    renderCart();

    alert('Order placed successfully!');
    window.location.href = 'orders.html';

  } catch (error) {
    console.error('Checkout error:', error);
    alert(error.message || 'Could not place the order.');
  }
}

/* ===== INITIALIZATION ===== */
document.addEventListener('DOMContentLoaded', () => {

  // Load products from MySQL
  loadCart();

  // Save notes locally
  const notesEl = document.getElementById('cartNotes');

  if (notesEl) {
    notesEl.value = getNotes();

    notesEl.addEventListener('input', () => {
      saveNotes(notesEl.value);
    });
  }

  // Clear cart button
  const clearBtn = document.getElementById('clearCartBtn');

  if (clearBtn) {
    clearBtn.addEventListener('click', clearCart);
  }

  // Checkout button
  const checkoutBtn = document.getElementById('checkoutBtn');

  if (checkoutBtn) {
    checkoutBtn.addEventListener('click', checkout);
  }

});
