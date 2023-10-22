import React from 'react';
import './SettingsFormInput.style.scss';

const SettingsFormInput = ({
  error,
  value,
  onChange,
  type = 'number',
  placeholder = 'Enter the Threshold',
  disabled = false,
}: {
  error?: boolean;
  value: any;
  onChange: any;
  type?: string;
  placeholder?: string;
  disabled?: boolean;
}) => {
  return (
    <div className="form-element input-container m-0">
      <input
        className={`form-input ${error ? 'form-input--error' : ''}`}
        placeholder={placeholder}
        value={value}
        onChange={(event) => onChange?.(event.target.value)}
        type={type}
        disabled={disabled}
      />
    </div>
  );
};

export default SettingsFormInput;
