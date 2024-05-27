document.getElementById('registerForm').addEventListener('submit', function(event) {
    var password = document.getElementById('password').value;
    var confirmPassword = document.getElementById('confirm_password').value;

    if (password != confirmPassword) {
        alert('Passwords do not match.');
        event.preventDefault(); // prevent form from submitting
    } else {
        window.location.href = 'home.html'; // redirect to home.html
    }
});