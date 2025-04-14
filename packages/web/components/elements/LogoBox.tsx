import { LIBRARY_LEFT_MENU_WIDTH } from '../templates/navMenu/LibraryMenu'
import { theme } from '../tokens/stitches.config'
import { RuminerFullLogo } from './images/RuminerFullLogo'
import { RuminerNameLogo } from './images/RuminerNameLogo'
import { SpanBox } from './LayoutPrimitives'

export function LogoBox(): JSX.Element {
  return (
    <>
      <SpanBox
        css={{
          pl: '25px',
          height: '24px',
          pointerEvents: 'all',
          width: LIBRARY_LEFT_MENU_WIDTH,
          minWidth: LIBRARY_LEFT_MENU_WIDTH,
          '@mdDown': {
            display: 'none',
          },
        }}
      >
        <RuminerFullLogo
          showTitle={true}
          color={theme.colors.thHighContrast.toString()}
        />
      </SpanBox>
      <SpanBox
        css={{
          ml: '15px',
          mr: '15px',

          display: 'none',

          lineHeight: '1',
          '@mdDown': {
            display: 'flex',
          },
        }}
      >
        <RuminerNameLogo color={theme.colors.thHighContrast.toString()} />
      </SpanBox>
    </>
  )
}
