import React from 'react';
import './SettingsFormInput.style.scss';

const SettingsFormInput = ({
  error,
  value,
  onChange,
  type = 'number',
  placeholder = 'Enter the Threshold',
  disabled = false,
  min="0.10",
  max="1.00", 
  step="0.01"
  }: {
  error?: boolean;
  value: any;
  onChange: any;
  type?: string;
  placeholder?: string;
  disabled?: boolean;
  min?:string;
  max?:string;
  step?:string;

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
        min={min}
        max={max}
        step={step}
      />
    </div>
  );
};

export default SettingsFormInput;
