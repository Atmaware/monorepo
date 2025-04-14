import { PageMetaData } from '../../components/patterns/PageMetaData'
import { About } from '../../components/templates/About'

export default function LandingPage(): JSX.Element {
  return (
    <>
      <PageMetaData
        title="Ruminer"
        path="/about"
        ogImage="/static/images/og-homepage-zh.png"
        description="Ruminer 为认真读者提供免付费read-it-later应用程序"
      />

      <About lang="zh" />
    </>
  )
}
