import pytest
from utils import is_valid_email
from utils import is_valid_email, is_strong_password

@pytest.mark.parametrize("email", [
    "user@example.com",
    "user.name+tag@sub.domain.co",
    "user_name@domain.org",
    "user-name@domain.io",
    "user123@domain123.com",
    "u@d.co",
    "user.name@domain.travel",
    "user@localhost.localdomain"
])
def test_is_valid_email_valid(email):
    assert is_valid_email(email) is True

@pytest.mark.parametrize("email", [
    "plainaddress",
    "@missingusername.com",
    "username@.com",
    "username@com",
    "username@domain..com",
    "username@domain.c",
    "username@domain.corporate1",
    "user name@domain.com",
    "user@domain,com",
    "user@domain",
    "user@.domain.com",
    "user@domain.com.",
    "",
    None
])
def test_is_valid_email_invalid(email):
    assert is_valid_email(email) is False

@pytest.mark.parametrize("password", [
    "Pass123!",
    "Abcdef1!",
    "MyP@ssw0rd",
    "Str0ng!Pass",
    "T3st_Pass",
    "Valid123#",
    "Secur3$Pass",
    "C0mpl3x!ty"
])
def test_is_strong_password_valid(password):
    assert is_strong_password(password) is True

@pytest.mark.parametrize("password", [
    "weak",
    "short1!",
    "nouppercase123!",
    "NOLOWERCASE123!",
    "NoDigits!",
    "NoSpecial123",
    "Pass123",
    "",
    "1234567",
    "abcdefgh",
    "ABCDEFGH",
    "Abc12345",
    "Abcdefg!",
    "12345!@#"
])
def test_is_strong_password_invalid(password):
    assert is_strong_password(password) is False
