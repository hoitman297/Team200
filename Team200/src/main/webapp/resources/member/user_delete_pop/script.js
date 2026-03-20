const checkbox = document.getElementById('withdrawCheck');
        const submitBtn = document.getElementById('submitBtn');

        checkbox.addEventListener('change', function() {
            if (this.checked) {
                submitBtn.classList.add('active');
            } else {
                submitBtn.classList.remove('active');
            }
        });