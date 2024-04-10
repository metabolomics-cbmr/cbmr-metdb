import React, { useEffect, useState } from 'react';
import './LoginPage.style.scss';
import Logo from '../../../../assets/images/portal/logo.svg';
import Input from '../../atoms/Input';
import { useHistory } from 'react-router';
import { ROUTES } from '../../../Routes';

const LoginPage = (props) => {
  let history = useHistory();

  const [userName, setUserName] = useState('');
  const [password, setPassword] = useState('');

  const [userNameError, setUserNameError] = useState(false);
  const [passwordError, setPasswordError] = useState(false);

  const navigateToDashboard = () => {
    history.push(ROUTES.DASHBOARD);
  };

  const login = () => {
    if (userName && password) {
      navigateToDashboard();
    } else {
      setUserNameError(!userName);
      setPasswordError(!password);
    }
  };

  useEffect(() => {
    if (userName) {
      setUserNameError(false);
    }
    if (password) {
      setPasswordError(false);
    }
  }, [userName, password]);

  return (
    <div className="login-page">
      <div className="login-page__overlay">
        <div className="login-form">
          <div className="login-form__title">
            <img src={Logo} alt="logo" className="login-form__logo" />
            <div className="login-form__title__text">
              Novo Nordisk Foundation
              <br />
              Center for Basic Metabolic Research
            </div>
          </div>
          <div className="login-form__fields">
            <Input
              label="Username"
              value={userName}
              onChange={setUserName}
              error={userNameError}
            />
            <Input
              label="Password"
              type="password"
              value={password}
              onChange={setPassword}
              error={passwordError}
            />
          </div>
          <div className="login-form__footer">
            <button className="btn--primary w-100" onClick={login}>
              Login
            </button>
          </div>
        </div>
      </div>
    </div>
  );
};

export default LoginPage;
