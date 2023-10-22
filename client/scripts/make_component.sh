mkdir $1
cd $1

touch index.tsx
touch $1.tsx
touch $1.style.scss

echo "export { default } from './$1'" >> index.tsx;
echo "" >> index.tsx;

echo "import React from 'react';" >> $1.tsx;
echo "import './$1.style.scss';" >> $1.tsx;
echo "" >> $1.tsx;
echo "const $1 = (props) => { " >> $1.tsx;
echo "  return (null);" >> $1.tsx;
echo "};" >> $1.tsx;
echo "" >> $1.tsx;
echo "export default $1;" >> $1.tsx;
npx prettier --write .