import { useState } from 'react';

const FileUploader = ({ title, placeholder, accept = '*', onFileSelect, multipleFiles=false}) => {

  const [fileName, setFileName] = useState(placeholder);

  const onFileChange = (event: React.ChangeEvent<HTMLInputElement>) => {

    var ufile:File[] =[]
    
    if (event.target.files) {
 
      for (let i = 0; i < event.target.files.length; i++) 
        ufile.push(event?.target?.files[i])

      onFileSelect(existing => existing.concat(ufile));

      setFileName(ufile.map(file => file.name + ","))

    }
    else
      setFileName(placeholder) ;

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
              multiple= {multipleFiles}

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
