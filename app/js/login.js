document.addEventListener('DOMContentLoaded', function () {
    const emailInput = document.getElementById('email');
    const emailError = document.getElementById('email-error');
    const loginButton = document.getElementById('login-btn');

    function validateForm() {
        const email = emailInput.value;

        // Check if passwords match and email is not already in use
        if (password !== '' && !emailError.textContent) {
            loginButton.disabled = false; // Enable button if passwords match and email is not in use
        } else {
            loginButton.disabled = true; // Disable button if passwords don't match or email is already in use
        }
    }

    emailInput.addEventListener('input', function () {
        const email = emailInput.value;
        if (email == '') {
            emailError.textContent = '';
            emailInput.style.borderColor = ''; // Reset border color
        } else {
            fetch('/serving/check_email', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: `email=${encodeURIComponent(email)}`
            })
                .then(response => response.json())
                .then(data => {
                    if (!data.exists) {
                        emailError.textContent = 'Email not registered';
                        emailInput.style.borderColor = 'red'; // Change border color to red
                    } else {
                        emailError.textContent = '';
                        emailInput.style.borderColor = ''; // Reset border color
                    }
                    validateForm(); // Validate form after email input changes
                })
                .catch(error => console.error('Error:', error));
        }
    });
});