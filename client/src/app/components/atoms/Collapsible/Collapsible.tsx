import React, { useCallback, useEffect, useState } from 'react';
import ReactCollapsible from 'react-collapsible';
import './Collapsible.style.scss';

const CollapsibleTrigger = (props) => {
  const { trigger } = props;
  return (
    <div className="collapsible-trigger--inner">
      {trigger}
      <span className="material-icons trigger-icon">keyboard_arrow_down</span>
    </div>
  );
};

const Collapsible = ({
  trigger,
  children,
  isOpen,
  id,
  onOpen = () => {},
  onClose = () => {},
  hasBorder = false,
}: {
  trigger: any;
  children: any;
  isOpen?: boolean;
  id?: any;
  onOpen?: any;
  onClose?: any;
  hasBorder?: boolean;
}) => {
  const [open, setOpen] = useState(false);
  const reactCollapsibleRef = React.createRef<ReactCollapsible>();
  const handleCollapsibleOpen = () => {
    onOpen();
    setOverFlow('visible');
  };
  const handleCollapsibleClosing = () => {
    setOverFlow('hidden');
  };

  const setOverFlow = useCallback(
    (overflow) => {
      const ref = reactCollapsibleRef.current as any;
      if (ref) {
        ref.innerRef.style.overflow = overflow;
      }
    },
    [reactCollapsibleRef],
  );

  useEffect(() => {
    if (isOpen !== open) {
      setOverFlow(isOpen ? 'visible' : 'hidden');
      setOpen(!!isOpen);
    }
  }, [open, isOpen, reactCollapsibleRef, setOverFlow]);

  return (
    <div
      className={`collapsible--custom ${
        hasBorder ? 'collapsible--custom--bordered' : ''
      }`}
    >
      <ReactCollapsible
        open={open}
        trigger={<CollapsibleTrigger trigger={trigger} />}
        onOpen={handleCollapsibleOpen}
        onClosing={handleCollapsibleClosing}
        ref={reactCollapsibleRef}
        onClose={onClose}
      >
        {children}
      </ReactCollapsible>
    </div>
  );
};

export default Collapsible;
