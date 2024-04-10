import { useHistory } from 'react-router';
import { ROUTES } from '../../../../Routes';
import { SIDEBAR } from '../../../../shared/constants';
import Sidebar from '../../../organisms/Sidebar';
import Docs from './Docs';

const DashboardSidebar = (props) => {
  const history = useHistory();
  return (
    <Sidebar
      sidebarItems={SIDEBAR}
      // activeItem={SIDEBAR[0]}
    >
      <Docs />
    </Sidebar>
  );
};

export default DashboardSidebar;
