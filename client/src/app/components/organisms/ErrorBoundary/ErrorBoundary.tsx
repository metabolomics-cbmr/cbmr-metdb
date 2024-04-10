import React from 'react';
import './ErrorBoundary.style.scss';

const ErrorBoundary = ({ children }) => {
  try {
    return children;
  } catch (error) {
    console.log({ errorBoundaryError: error });
    return <>An Error Occured</>;
  }
};

export default ErrorBoundary;
