// Navigation Interceptor for PropVeil Stitch Screens
(function() {
  console.log("PropVeil Nav Interceptor loaded.");

  // Helper to get printable/searchable text from an element
  function getElementText(el) {
    let text = el.innerText || el.textContent || "";
    // Clean up text: replace multiple whitespaces and newlines
    text = text.replace(/\s+/g, ' ').trim();
    return text;
  }

  // Intercept click events
  document.addEventListener('click', function(e) {
    // Traverse up to find clickable element
    let target = e.target;
    let clickable = null;
    
    while (target && target !== document.body) {
      const tag = target.tagName.toLowerCase();
      const isButton = tag === 'button' || target.getAttribute('role') === 'button';
      const isLink = tag === 'a';
      const isCard = target.classList.contains('bg-bg-surface') || 
                     target.classList.contains('p-4') || 
                     target.classList.contains('border-subtle') || 
                     target.getAttribute('onclick') !== null;
                     
      if (isButton || isLink || isCard) {
        clickable = target;
        break;
      }
      target = target.parentElement;
    }

    if (!clickable) {
      const hasInteractive = document.querySelector('button, a, [role="button"]') !== null;
      if (!hasInteractive) {
        clickable = document.body;
      }
    }

    if (clickable) {
      const text = getElementText(clickable);
      const classes = clickable.className || "";
      const tag = clickable.tagName.toLowerCase();
      
      // Determine if it is a back button
      let isBack = false;
      if (text.toLowerCase().includes("retour") || 
          text.toLowerCase().includes("back") || 
          classes.includes("arrow_back") || 
          clickable.querySelector('.material-symbols-outlined')?.innerText === 'arrow_back_ios_new' ||
          clickable.querySelector('.material-symbols-outlined')?.innerText === 'arrow_back') {
        isBack = true;
      }

      console.log("Click intercepted:", text, "IsBack:", isBack);

      const payload = {
        action: isBack ? 'back' : 'click',
        text: text,
        tagName: tag,
        classes: classes
      };

      if (window.NavigationChannel) {
        if (tag === 'a' && (!clickable.getAttribute('href') || clickable.getAttribute('href') === '#')) {
          e.preventDefault();
        }
        window.NavigationChannel.postMessage(JSON.stringify(payload));
      } else {
        if (tag === 'a' && (!clickable.getAttribute('href') || clickable.getAttribute('href') === '#')) {
          e.preventDefault();
        }
        window.parent.postMessage(JSON.stringify({
          type: 'navigation',
          data: payload
        }), '*');
      }
    }
  }, true); // Capture phase to intercept early
})();
