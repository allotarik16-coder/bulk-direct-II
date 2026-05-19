export default function Home() {
  return (
    <main style={{
      minHeight: '100vh',
      backgroundColor: '#0f172a',
      color: '#ffffff',
      display: 'flex',
      flexDirection: 'column',
      justifyContent: 'center',
      alignItems: 'center',
      padding: '20px',
      fontFamily: 'monospace'
    }}>
      <h1 style={{ fontSize: '48px', marginBottom: '20px' }}>
        BULK<span style={{ color: '#22d3ee' }}>DIRECT</span>
      </h1>
      
      <p style={{ fontSize: '18px', color: '#94a3b8', marginBottom: '40px' }}>
        B2B Marketplace + Reddit Intelligence Pipeline
      </p>

      <div style={{
        backgroundColor: '#1e293b',
        padding: '30px',
        borderRadius: '8px',
        border: '1px solid #334155',
        maxWidth: '600px',
        textAlign: 'center'
      }}>
        <h2 style={{ marginBottom: '20px' }}>🚀 Coming Soon</h2>
        
        <p style={{ marginBottom: '15px', lineHeight: '1.6' }}>
          Discover B2B opportunities from Reddit.
        </p>
        
        <p style={{ marginBottom: '15px', lineHeight: '1.6' }}>
          Powered by Claude AI + Supabase
        </p>

        <div style={{
          marginTop: '30px',
          padding: '20px',
          backgroundColor: '#0f172a',
          borderRadius: '6px',
          fontSize: '14px'
        }}>
          <p style={{ margin: '5px 0' }}>✅ Supabase Connected</p>
          <p style={{ margin: '5px 0' }}>✅ Variables Set</p>
          <p style={{ margin: '5px 0' }}>✅ Ready for Development</p>
        </div>
      </div>

      <footer style={{
        marginTop: '60px',
        color: '#64748b',
        fontSize: '14px'
      }}>
        <p>Built with ❤️ by Tarik</p>
        <p>@iaproductbuilder</p>
      </footer>
    </main>
  );
}
