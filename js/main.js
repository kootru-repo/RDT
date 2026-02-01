/**
 * Relational Drainage Theory - Main JavaScript
 * Version 2.1 | January 2026
 *
 * Handles KaTeX rendering, navigation, and interactive features.
 */

(function() {
  'use strict';

  // ============================================
  // CONFIGURATION
  // ============================================
  const CONFIG = {
    katex: {
      delimiters: [
        { left: '$$', right: '$$', display: true },
        { left: '$', right: '$', display: false },
        { left: '\\[', right: '\\]', display: true },
        { left: '\\(', right: '\\)', display: false }
      ],
      throwOnError: false,
      errorColor: '#cc0000',
      strict: false,
      trust: true
    },
    scrollOffset: 80,
    highlightDuration: 1500
  };

  // ============================================
  // KATEX RENDERING
  // ============================================
  function initKaTeX() {
    if (typeof renderMathInElement === 'function') {
      renderMathInElement(document.body, CONFIG.katex);
      console.log('KaTeX rendering complete');
    } else {
      console.warn('KaTeX auto-render not loaded');
    }
  }

  // ============================================
  // SMOOTH SCROLLING
  // ============================================
  function initSmoothScrolling() {
    document.querySelectorAll('a[href^="#"]').forEach(anchor => {
      anchor.addEventListener('click', function(e) {
        const targetId = this.getAttribute('href');
        if (targetId === '#') return;

        const targetElement = document.querySelector(targetId);
        if (targetElement) {
          e.preventDefault();
          const targetPosition = targetElement.getBoundingClientRect().top + window.pageYOffset - CONFIG.scrollOffset;

          window.scrollTo({
            top: targetPosition,
            behavior: 'smooth'
          });

          // Update URL without jumping
          history.pushState(null, null, targetId);

          // Highlight the section briefly
          highlightSection(targetElement);
        }
      });
    });
  }

  // ============================================
  // SECTION HIGHLIGHTING
  // ============================================
  function highlightSection(element) {
    element.classList.add('section-highlight');
    setTimeout(() => {
      element.classList.remove('section-highlight');
    }, CONFIG.highlightDuration);
  }

  // ============================================
  // TABLE OF CONTENTS - ACTIVE STATE
  // ============================================
  function initTOCActiveState() {
    const sections = document.querySelectorAll('section[id]');
    const tocLinks = document.querySelectorAll('.toc-link');

    if (sections.length === 0 || tocLinks.length === 0) return;

    const observerOptions = {
      rootMargin: '-20% 0px -80% 0px',
      threshold: 0
    };

    const observer = new IntersectionObserver((entries) => {
      entries.forEach(entry => {
        if (entry.isIntersecting) {
          tocLinks.forEach(link => link.classList.remove('active'));
          const activeLink = document.querySelector(`.toc-link[href="#${entry.target.id}"]`);
          if (activeLink) {
            activeLink.classList.add('active');
          }
        }
      });
    }, observerOptions);

    sections.forEach(section => observer.observe(section));
  }

  // ============================================
  // READING PROGRESS INDICATOR
  // ============================================
  function initProgressIndicator() {
    const progressBar = document.createElement('div');
    progressBar.className = 'reading-progress';
    progressBar.setAttribute('role', 'progressbar');
    progressBar.setAttribute('aria-label', 'Reading progress');
    document.body.prepend(progressBar);

    function updateProgress() {
      const scrollTop = window.scrollY;
      const docHeight = document.documentElement.scrollHeight - window.innerHeight;
      const progress = docHeight > 0 ? (scrollTop / docHeight) * 100 : 0;
      progressBar.style.width = `${progress}%`;
      progressBar.setAttribute('aria-valuenow', Math.round(progress));
    }

    window.addEventListener('scroll', updateProgress, { passive: true });
    updateProgress();
  }

  // ============================================
  // BACK TO TOP BUTTON
  // ============================================
  function initBackToTop() {
    const button = document.createElement('button');
    button.className = 'back-to-top';
    button.innerHTML = '&uarr;';
    button.setAttribute('aria-label', 'Back to top');
    button.setAttribute('title', 'Back to top');
    document.body.appendChild(button);

    function toggleButton() {
      if (window.scrollY > 300) {
        button.classList.add('visible');
      } else {
        button.classList.remove('visible');
      }
    }

    button.addEventListener('click', () => {
      window.scrollTo({ top: 0, behavior: 'smooth' });
    });

    window.addEventListener('scroll', toggleButton, { passive: true });
    toggleButton();
  }

  // ============================================
  // PRINT FUNCTIONALITY
  // ============================================
  function initPrintButton() {
    const printBtn = document.querySelector('.print-btn');
    if (printBtn) {
      printBtn.addEventListener('click', () => {
        window.print();
      });
    }
  }

  // ============================================
  // COPY EQUATION FUNCTIONALITY
  // ============================================
  function initEquationCopy() {
    document.querySelectorAll('.boxed').forEach(box => {
      box.style.cursor = 'pointer';
      box.setAttribute('title', 'Click to copy equation');

      box.addEventListener('click', async () => {
        const katexElement = box.querySelector('.katex');
        if (katexElement) {
          const annotation = katexElement.querySelector('annotation');
          if (annotation) {
            const latex = annotation.textContent;
            try {
              await navigator.clipboard.writeText(latex);
              showToast('Equation copied to clipboard');
            } catch (err) {
              console.error('Failed to copy:', err);
            }
          }
        }
      });
    });
  }

  // ============================================
  // TOAST NOTIFICATIONS
  // ============================================
  function showToast(message, duration = 2000) {
    const toast = document.createElement('div');
    toast.className = 'toast';
    toast.textContent = message;
    toast.setAttribute('role', 'alert');
    document.body.appendChild(toast);

    // Trigger animation
    requestAnimationFrame(() => {
      toast.classList.add('visible');
    });

    setTimeout(() => {
      toast.classList.remove('visible');
      setTimeout(() => toast.remove(), 300);
    }, duration);
  }

  // ============================================
  // ACCESSIBILITY ENHANCEMENTS
  // ============================================
  function initAccessibility() {
    // Add skip link
    const skipLink = document.createElement('a');
    skipLink.href = '#main-content';
    skipLink.className = 'skip-link';
    skipLink.textContent = 'Skip to main content';
    document.body.prepend(skipLink);

    // Ensure all images have alt text (if any are added later)
    document.querySelectorAll('img:not([alt])').forEach(img => {
      img.setAttribute('alt', '');
    });

    // Add aria-current to active TOC link
    const currentSection = window.location.hash;
    if (currentSection) {
      const activeLink = document.querySelector(`.toc-link[href="${currentSection}"]`);
      if (activeLink) {
        activeLink.setAttribute('aria-current', 'location');
      }
    }
  }

  // ============================================
  // KEYBOARD NAVIGATION
  // ============================================
  function initKeyboardNav() {
    document.addEventListener('keydown', (e) => {
      // Alt + T: Go to Table of Contents
      if (e.altKey && e.key === 't') {
        e.preventDefault();
        const toc = document.querySelector('.toc');
        if (toc) {
          toc.scrollIntoView({ behavior: 'smooth' });
          toc.querySelector('a')?.focus();
        }
      }

      // Alt + Home: Go to top
      if (e.altKey && e.key === 'Home') {
        e.preventDefault();
        window.scrollTo({ top: 0, behavior: 'smooth' });
      }
    });
  }

  // ============================================
  // INITIALIZATION
  // ============================================
  function init() {
    // Wait for DOM to be fully loaded
    initKaTeX();
    initSmoothScrolling();
    initTOCActiveState();
    initProgressIndicator();
    initBackToTop();
    initPrintButton();
    initEquationCopy();
    initAccessibility();
    initKeyboardNav();

    console.log('RDT Framework initialized');
  }

  // Run on DOM ready
  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', init);
  } else {
    init();
  }
})();
