// SmartResume Application JavaScript
console.log('SmartResume loaded');

// Simple form validation
document.addEventListener('DOMContentLoaded', () => {
  console.log('DOM loaded');
  const forms = document.querySelectorAll('form');
  forms.forEach(form => {
    form.addEventListener('submit', (e) => {
      const fileInput = form.querySelector('input[type="file"]');
      if (fileInput && fileInput.required && !fileInput.files.length) {
        e.preventDefault();
        alert('Please select a file');
      }
    });
  });
});
