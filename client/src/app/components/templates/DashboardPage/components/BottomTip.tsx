import { SyntheticEvent } from 'react';
import arrowRight from '../../../../../assets/images/arrow-right.svg';

const BottomTip = ({ text, onClick = () => {} }) => {
  const handleClick = (event: SyntheticEvent) => {
    // event?.stopPropagation();
    // event?.preventDefault();
    onClick?.();
    // return false;
  };
  return (
    <div
      className="bottom-text flex-row underline cursor-pointer"
      onClick={handleClick}
    >
      <u>{text}</u>
      <img className="arrow-right ml-2" src={arrowRight} alt="" />
    </div>
  );
};

export default BottomTip;
