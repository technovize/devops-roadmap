import pytest
from unittest.mock import patch, MagicMock
from health_check import check_service_health

def test_healthy_service_returns_true():
    with patch("requests.get") as mock_get:
        mock_get.return_value = MagicMock(status_code=200)
        assert check_service_health("http://api.example.com/health") == True

def test_unhealthy_service_returns_false():
    with patch("requests.get") as mock_get:
        mock_get.return_value = MagicMock(status_code=503)
        assert check_service_health("http://api.example.com/health") == False
