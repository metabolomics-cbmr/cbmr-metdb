import { useState } from 'react';
import { Button, Modal } from 'react-bootstrap';
import './ModalWrapper.style.scss';

const ModalWrapper = ({
  title,
  children,
  onClickSave,
  onCancel,
  closeButtonText = 'Cancel',
  open = true,
  isSaveEnabled = true,
  saveButtonText = '',
}: {
  title: string;
  children: any;
  onClickSave?: any;
  onCancel?: any;
  closeButtonText?: string;
  open?: boolean;
  isSaveEnabled?: any;
  saveButtonText?: any;
}) => {
  const [showModal, setShowModal] = useState(open);
  const closeModal = () => {
    setShowModal(false);
    onCancel?.();
  };
  return (
    <Modal show={showModal} onHide={closeModal} backdrop="static">
      <Modal.Header closeButton>
        <Modal.Title>{title}</Modal.Title>
      </Modal.Header>
      <Modal.Body style={{ maxHeight: '60vh', overflow: 'auto' }}>
        {children}
      </Modal.Body>
      <Modal.Footer>
        <div className="modal-close-button" role="button" onClick={closeModal}>
          {closeButtonText}
        </div>
        {saveButtonText && (
          <Button disabled={!isSaveEnabled} onClick={onClickSave}>
            {saveButtonText}
          </Button>
        )}
      </Modal.Footer>
    </Modal>
  );
};

export default ModalWrapper;
