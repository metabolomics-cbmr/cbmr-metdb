import { Link } from 'react-router-dom';
import Card from '../../../atoms/Card';
import ModuleGradient from '../../../atoms/ModuleGradient';

const DashboardModule = (props: {
  href?: string;
  title: string;
  description: string;
  index: number;
  moduleImage: any;
  bottomControls: any;
  onClick?: any;
}) => {
  const {
    index,
    href,
    title,
    description,
    bottomControls,
    moduleImage,
    onClick,
  } = props;
  const LinkWrapper = ({ children }) =>
    href ? (
      <Link to={href} key={index}>
        {children}
      </Link>
    ) : (
      <>{children}</>
    );
  return (
    <LinkWrapper>
      <Card className="dashboard-module" key={index} onClick={onClick}>
        <div className="dashboard-module__left">
          <p className="dashboard-module__title">{title}</p>
          <p className="dashboard-module__subtitle">{description}</p>
          {bottomControls}
        </div>
        <ModuleGradient className="dashboard-module__right text-center">
          {moduleImage}
        </ModuleGradient>
      </Card>
    </LinkWrapper>
  );
};

export default DashboardModule;
