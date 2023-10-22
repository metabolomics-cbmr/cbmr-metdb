import { useState } from 'react';

const FileUploader = ({ title, placeholder, accept = '*', onFileSelect }) => {
  const [fileName, setFileName] = useState(placeholder);
  const onFileChange = (event: React.ChangeEvent<HTMLInputElement>) => {
    const file = event?.target?.files?.[0];
    console.log(event, file);
    onFileSelect(file);
    if (file) {
      setFileName(file.name);
    } else {
      setFileName(placeholder);
    }
  };
  return (
    <div className="form-element">
      <div className="label-container">
        <label className="form__label">{title}</label>
      </div>
      <div className="input-group mb-3">
        <div className="custom-file">
          <input
            type="file"
            className="custom-file-input"
            id="inputGroupFile01"
            accept={accept}
            onChange={onFileChange}
          />
          <label className="custom-file-label" htmlFor="inputGroupFile01">
            {fileName}
          </label>
        </div>
      </div>
    </div>
  );
};

export default FileUploader;
