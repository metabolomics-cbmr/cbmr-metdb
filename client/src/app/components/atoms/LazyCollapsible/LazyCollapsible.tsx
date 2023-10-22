import React, { useState } from 'react';
import Collapsible from '../Collapsible';
import './LazyCollapsible.style.scss';

const LazyCollapsible = ({ children, onOpen, onClose, ...props }: any) => {
  const [isOpen, setIsOpen] = useState(false);
  const handleCollapsibleOpen = () => {
    setIsOpen(true);
    onOpen?.();
  };
  const handleCollapsibleClose = () => {
    setIsOpen(false);
    onClose?.();
  };
  return (
    <Collapsible
      {...props}
      onOpen={handleCollapsibleOpen}
      onClose={handleCollapsibleClose}
    >
      {isOpen ? children : <p className="text-secondary">Loading Data...</p>}
    </Collapsible>
  );
};

export default LazyCollapsible;
