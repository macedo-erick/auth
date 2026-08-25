(function () {
  var form = document.querySelector('form[data-mail-domain]');
  if (!form) return;

  var domain = form.getAttribute('data-mail-domain');
  var steps = Array.prototype.slice.call(form.querySelectorAll('.stx-step'));
  var dots = Array.prototype.slice.call(form.querySelectorAll('[data-step-dot]'));
  var address = form.querySelector('[data-address]');
  var mirrors = Array.prototype.slice.call(form.querySelectorAll('[data-address-mirror]'));
  var current = null;

  function fullAddress() {
    var raw = address ? address.value.trim() : '';
    if (!raw) return '';
    return raw.indexOf('@') === -1 ? raw + '@' + domain : raw;
  }

  function show(step) {
    var found = false;
    steps.forEach(function (section) {
      var match = section.getAttribute('data-step') === String(step);
      section.hidden = !match;
      if (match) found = true;
    });
    if (!found) return;
    current = String(step);
    dots.forEach(function (dot) {
      dot.classList.toggle('is-current', dot.getAttribute('data-step-dot') === current);
    });
    var echo = fullAddress();
    form.querySelectorAll('[data-address-echo]').forEach(function (node) {
      node.textContent = echo;
    });
    var first = form.querySelector('.stx-step:not([hidden]) input:not([type="hidden"])');
    if (first) first.focus();
  }

  function invalid(input, message) {
    input.setAttribute('aria-invalid', 'true');
    var field = input.closest('.stx-field') || input.closest('.stx-check');
    if (field) field.classList.add('stx-field--error');
    var note = field && field.parentNode.querySelector('.stx-error--live');
    if (!note) {
      note = document.createElement('p');
      note.className = 'stx-error stx-error--live';
      note.setAttribute('aria-live', 'polite');
      if (field) field.parentNode.insertBefore(note, field.nextSibling);
    }
    note.textContent = message;
    input.focus();
  }

  function clearLive(section) {
    section.parentNode.querySelectorAll('.stx-error--live').forEach(function (n) { n.remove(); });
    section.querySelectorAll('[aria-invalid="true"]').forEach(function (n) {
      n.setAttribute('aria-invalid', 'false');
    });
  }

  // Only the step being left is validated; the server stays the authority on the rest.
  function stepIsValid(section) {
    clearLive(section);
    if (address && !address.closest('[hidden]')) {
      var local = address.value.trim();
      if (!local) {
        invalid(address, 'Enter the part of the address before the @.');
        return false;
      }
      if (local.indexOf('@') !== -1 && local.slice(local.indexOf('@') + 1) !== domain) {
        invalid(address, 'Stampyx addresses end in @' + domain + '.');
        return false;
      }
      if (!/^[A-Za-z0-9](?:[A-Za-z0-9._-]*[A-Za-z0-9])?$/.test(local.split('@')[0])) {
        invalid(address, 'Use letters, numbers, dots or hyphens.');
        return false;
      }
    }
    var missing = Array.prototype.slice.call(section.querySelectorAll('[data-required]')).filter(function (input) {
      return input.type === 'checkbox' ? !input.checked : !input.value.trim();
    });
    if (missing.length) {
      invalid(missing[0], 'This field is required.');
      return false;
    }
    var confirm = section.querySelector('#password-confirm');
    var password = section.querySelector('#password');
    if (confirm && password && confirm.value && confirm.value !== password.value) {
      invalid(confirm, 'The passwords do not match.');
      return false;
    }
    return true;
  }

  form.addEventListener('click', function (event) {
    var trigger = event.target.closest('[data-goto-step]');
    if (!trigger) return;
    event.preventDefault();
    var target = trigger.getAttribute('data-goto-step');
    var section = trigger.closest('.stx-step');
    if (Number(target) > Number(current) && section && !stepIsValid(section)) return;
    show(target);
  });

  form.addEventListener('keydown', function (event) {
    if (event.key !== 'Enter') return;
    var section = event.target.closest('.stx-step');
    var next = section && section.querySelector('[data-goto-step]:not(.stx-link-btn)');
    if (!next || event.target.tagName !== 'INPUT') return;
    event.preventDefault();
    next.click();
  });

  form.addEventListener('submit', function (event) {
    var section = form.querySelector('.stx-step:not([hidden])');
    if (section && !stepIsValid(section)) {
      event.preventDefault();
      return;
    }
    var full = fullAddress();
    mirrors.forEach(function (input) { input.value = full; });
    if (address) address.value = full;
  });

  form.addEventListener('click', function (event) {
    var toggle = event.target.closest('[data-reveal]');
    if (!toggle) return;
    var input = document.getElementById(toggle.getAttribute('data-reveal'));
    if (!input) return;
    var revealed = input.type === 'text';
    input.type = revealed ? 'password' : 'text';
    toggle.classList.toggle('is-on', !revealed);
    toggle.setAttribute('aria-pressed', String(!revealed));
  });

  var policies = window.stxPasswordPolicies || [];
  var policyHelp = document.getElementById('stx-password-help');
  if (policies.length && policyHelp) {
    var rules = {
      length: function (v, n) { return v.length >= n; },
      maxLength: function (v, n) { return v.length <= n; },
      lowerCase: function (v, n) { return (v.match(/[a-z]/g) || []).length >= n; },
      upperCase: function (v, n) { return (v.match(/[A-Z]/g) || []).length >= n; },
      digits: function (v, n) { return (v.match(/[0-9]/g) || []).length >= n; },
      specialChars: function (v, n) { return (v.match(/[^A-Za-z0-9]/g) || []).length >= n; }
    };
    var describe = function (policy) {
      return policy.error.replace('{0}', policy.value);
    };
    policyHelp.textContent = policies.map(describe).join(' · ');
    var passwordInput = document.getElementById('password');
    if (passwordInput) {
      passwordInput.addEventListener('input', function () {
        var unmet = policies.filter(function (p) {
          return rules[p.name] && !rules[p.name](passwordInput.value, p.value);
        });
        policyHelp.textContent = unmet.length ? unmet.map(describe).join(' · ') : 'Password meets every rule.';
        policyHelp.classList.toggle('stx-help--ok', !unmet.length && passwordInput.value.length > 0);
      });
    }
  }

  show(form.getAttribute('data-initial-step') || '1');
})();
