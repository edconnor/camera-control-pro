//
//  NikonManager.h
//  Camera Control Pro
//
//  Created by Eduardo Connor on 1/6/21.
//

#ifndef NikonManager_h
#define NikonManager_h

#include "Maid3.h"
#include "Maid3d1.h"
#include "CtrlSample.h"

class NikonManager
{
    static NikonManager *instance;
    
public:
    NikonManager();
    virtual ~NikonManager();
    
    friend class AsyncManager;
    
    static NikonManager *getInstance() {
          if (!instance)
          instance = new NikonManager;
          return instance;
    }
    
    // this method is a mirror of GetInstance
    static void resetInstance()
    {
        delete instance; // It works even if the pointer is NULL (does nothing then)
        instance = NULL; // So getInstance will still work.
    }

    void async(void);
    void getCap(ULONG ulParam, ULONG ulDataType, NKPARAM pData);
    
    int         getCapUnsigned  (ULONG ulCapID, ULONG* ulValue);
    BYTE        getCapBool      (ULONG ulCapID);
    double      getCapDouble    (ULONG ulCapID);
    int         getCapEnumIndex (ULONG ulCapID); // returns current index (zero-based)
    int         getCapRange     (ULONG ulCapID, LPNkMAIDRange pRange);
    bool        getCapString    (ULONG ulCapID,  char *psString);
    
    
    bool        setCapBool      (ULONG ulCapID, bool bFlag);
    bool        setCapUnsigned  (ULONG ulCapID, ULONG ulValue);
    bool        setCapDouble    (ULONG ulCapID, double fValue);
    bool        setCapEnum      (ULONG ulCapID, int index);
    bool        setCapRange     (ULONG ulCapID, double fValue);
    
    int getCapCount();
    
    bool getCapInfo(LPNkMAIDCapInfo ppCapArray, int count);
    bool getCapArray (LPNkMAIDEnum pStEnum, int capId);
    
    char * getEnumString(int capId, int itemId);
    
    bool canSet (int capId);

    
    bool enumCapabilities( ULONG* pulCapCount, LPNkMAIDCapInfo* ppCapArray, LPNKFUNC pfnComplete, NKREF refComplete);

    LPRefObj    pRefSrc = NULL;
    
    bool resetSourceCommandLoop (int ulSrcID);
  
private:
    bool sourceCommandLoop( LPRefObj pRefMod, ULONG ulSrcID );
    
    LPRefObj    pRefMod = NULL;
    char        psEnumItemString[64];
    ULONG       ulModID = 0;
    ULONG       ulSrcID = 0;
    bool        m_asyncPaused = true;
};

class AsyncManager
{
public:
    AsyncManager() {}
    AsyncManager(NikonManager *mgr);
    virtual ~AsyncManager();
    
private:
    NikonManager *m_mgr = 0;
};
#endif /* NikonManager_h */
