# CipherLend - Decentralized P2P Lending Platform 🏦

CipherLend is a privacy-first peer-to-peer lending platform built on Web3 infrastructure, combining traditional financial document analysis with cutting-edge privacy technology.

## 🚀 What is CipherLend?

CipherLend enables **borrowers** to request loans by uploading financial documents (bank statements, bills, income proof) that are analyzed by AI and encrypted using Nillion's SecretVault technology. **Lenders** can assess loan applications by viewing AI-generated summaries without accessing raw financial documents, ensuring borrower privacy while enabling informed lending decisions.

### Key Features

- 🔐 **Privacy-First**: Documents encrypted in Nillion SecretVault - only borrowers can decrypt raw files
- 🤖 **AI Document Analysis**: AI analyzes financial documents and extracts key insights
- 💰 **P2P Lending**: Direct borrower-lender matching without traditional banking intermediaries
- 🌍 **Global Access**: Web3-based, accessible worldwide with crypto wallet integration
- 📊 **Humanity Score**: Gitcoin Passport integration for identity verification
- 🔗 **Blockchain Integration**: Wallet connections via RainbowKit/WagMi

## 🏗️ Technical Architecture

### Frontend Stack
- **Next.js 15** - React framework with App Router
- **TypeScript** - Type-safe development
- **Tailwind CSS** - Utility-first styling with custom neo-brutalist design
- **Clerk** - Authentication and user management
- **Convex** - Real-time database and backend logic
- **RainbowKit/WagMI** - Web3 wallet integration

### Privacy & Security
- **Nillion AI** - Provide private AI assessments
- **Nillion SecretVault** - Encrypted document storage with user-controlled access
- **Gitcoin Passport** - Humanity verification and scoring

### Database Schema (Convex)
```
users/ - User profiles and preferences
loanRequests/ - Loan applications with terms
documents/ - Financial document metadata (encrypted files in SecretVault)
assessments/ - Lender evaluations of loan requests
wallets/ - User wallet connections
```

## 📁 Project Structure

```
├── app/                          # Next.js App Router pages
│   ├── api/                      # API routes
│   │   ├── analyze-document/     # AI document analysis
│   │   ├── generate-keypair/     # SecretVault keypair generation
│   │   ├── vault-operations/     # Document encryption/decryption
│   │   └── verify-score/         # Gitcoin Passport verification
│   ├── borrow/                   # Borrower interface
│   │   ├── new/                  # Create loan request
│   │   └── [shortId]/            # View specific loan request
│   ├── lend/                     # Lender interface
│   │   └── [shortId]/            # Assess loan requests
│   └── profile/                  # User profile management
├── components/
│   ├── borrower/                 # Borrower-specific components
│   │   ├── LoanRequestBuilder.tsx    # Loan creation form
│   │   ├── UploadPanel.tsx           # General document upload
│   │   ├── LoanRequestUploadPanel.tsx # Loan-specific uploads
│   │   ├── SecretVaultManager.tsx    # SecretVault integration
│   │   └── HumanityScore.tsx         # Gitcoin Passport display
│   ├── lender/                   # Lender-specific components
│   │   ├── BorrowerCard.tsx          # Loan request display
│   │   └── AssessmentModal.tsx       # Loan evaluation interface
│   └── ui/                       # Reusable UI components (Neo-brutalist design)
├── convex/                       # Backend logic and database
│   ├── users.ts                  # User management
│   ├── loanRequests.ts          # Loan CRUD operations
│   ├── documents.ts             # Document metadata management
│   └── assessments.ts           # Lender evaluations
└── lib/
    ├── secretvaults.ts          # Nillion integration
    └── loan-utils.ts            # Loan calculation utilities
```

## 🔄 User Workflow

### For Borrowers:
1. **Sign Up** → Clerk authentication
2. **Generate SecretVault Keypair** → Privacy setup for document encryption
3. **Create Loan Request** → Specify amount, terms, purpose
4. **Upload Documents** → Bank statements, bills, income proof (AI analyzed + encrypted)
5. **Wait for Lenders** → Receive assessments and funding offers
6. **Accept Funding** → Connect wallet and receive funds

### For Lenders:
1. **Sign Up** → Clerk authentication  
2. **Browse Loan Requests** → View AI-generated summaries
3. **Assess Applications** → Evaluate risk based on financial insights
4. **Fund Loans** → Connect wallet and transfer funds to borrowers

### Privacy Flow:
1. **Document Upload** → Files analyzed by OpenAI API
2. **Encryption** → Raw documents + analysis stored in SecretVault (user-controlled)
3. **Summary Sharing** → Only AI summaries visible to lenders
4. **Access Control** → Borrowers can grant/revoke document access

## 🛠️ Development Setup

### Prerequisites
- Node.js 18+
- npm/yarn/pnpm
- Convex account
- Clerk account
- OpenAI API key
- Nillion API key

### Environment Variables
```bash
# Convex
CONVEX_DEPLOYMENT=dev:your-deployment
NEXT_PUBLIC_CONVEX_URL=https://your-deployment.convex.cloud

# Clerk Authentication
NEXT_PUBLIC_CLERK_PUBLISHABLE_KEY=pk_test_...
CLERK_SECRET_KEY=sk_test_...

# OpenAI
OPENAI_API_KEY=sk-...

# Nillion SecretVault
NILLION_BUILDER_PRIVATE_KEY=your-builder-key
NILLION_USER_KEY=your-user-key

# Gitcoin Passport
PASSPORT_API_KEY=your-passport-key
NEXT_PUBLIC_PASSPORT_SCORER_ID=your-scorer-id

# Wallet Connect
NEXT_PUBLIC_REOWN_PROJECT_ID=your-project-id
```

### Installation & Running
```bash
# Install dependencies
npm install

# Start Convex development
npx convex dev

# Start Next.js development server
npm run dev
```

### Key API Endpoints
- `POST /api/analyze-document` - Analyze financial documents with OpenAI
- `POST /api/generate-keypair` - Create SecretVault encryption keypair
- `POST /api/vault-operations` - Store/retrieve encrypted documents
- `POST /api/verify-score` - Verify Gitcoin Passport humanity score

## 🔐 Security & Privacy

### Document Privacy Architecture
1. **Upload** → Files sent to OpenAI for analysis (temporary)
2. **Analysis** → AI extracts financial insights and categories
3. **Encryption** → Raw files + analysis encrypted in SecretVault
4. **Access Control** → Users control who can decrypt their documents
5. **Sharing** → Lenders only see AI summaries, never raw documents

### SecretVault Integration
- Each user generates a unique encryption keypair
- Documents stored encrypted with user-controlled access
- Delegation tokens enable secure sharing with specific parties
- Zero-knowledge architecture - platform cannot decrypt user documents

## 🤝 Contributing

### Development Guidelines
- Follow TypeScript strict mode
- Use Tailwind for styling (neo-brutalist design system)
- All forms use Convex mutations for data persistence
- Privacy-first: always encrypt sensitive documents
- Real-time updates via Convex subscriptions

### Testing Components
- `StoreToVaultButton` - Test SecretVault integration
- `NilaiTestComponent` - Test document analysis
- Upload panels have built-in privacy checks

### Code Organization
- **Components**: Reusable UI in `/components/ui/`
- **Feature Components**: Domain-specific in `/components/borrower/` or `/components/lender/`
- **Backend Logic**: Convex functions in `/convex/`
- **API Routes**: External integrations in `/app/api/`

## 📚 Key Technologies

- **[Convex](https://convex.dev/)** - Real-time backend and database
- **[Clerk](https://clerk.com/)** - Authentication and user management  
- **[Nillion](https://nillion.com/)** - Privacy-preserving data storage
- **[Gitcoin Passport](https://passport.gitcoin.co/)** - Identity verification
- **[RainbowKit](https://rainbowkit.com/)** - Web3 wallet connections

## 🎯 Vision

CipherLend aims to democratize access to credit while preserving financial privacy. By combining AI-powered document analysis with zero-knowledge encryption, we enable global P2P lending without compromising sensitive financial data.

The platform bridges traditional finance (bank statements, credit scores) with Web3 infrastructure (wallet connections, decentralized storage), creating a new paradigm for privacy-preserving financial services.

