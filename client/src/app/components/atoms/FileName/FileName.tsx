import React from 'react';
import './FileName.style.scss';

export const formatFileName = (fileName: string) => {
  const FILE_PATH_PREFIX = '/Bio-Dev/metabolomics/uploads/';
  return fileName.replace(FILE_PATH_PREFIX, '');
};

const FileName = ({ children }: { children: string }) => {
  return <>{formatFileName(children)}</>;
};

export default FileName;
