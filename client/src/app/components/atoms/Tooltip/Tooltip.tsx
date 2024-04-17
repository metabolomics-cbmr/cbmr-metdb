import { Tooltip as ReactTooltip } from 'react-tooltip'

const Tooltip = (props) => {
    const {
        id="",
        content = '',
      } = props;
    
    //   <ReactTooltip anchorSelect={anchorSelect} content={content} />

      return (
        <>
        <a  data-tooltip-id={id}   data-tooltip-html={content}>
            {props.children}
      </a>
        <ReactTooltip id ={id} />

      </>
    )
}

export default Tooltip;