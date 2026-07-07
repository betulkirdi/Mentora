import os

from dotenv import load_dotenv
from fastapi import FastAPI, HTTPException, File, UploadFile  
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from typing import Optional
import httpx
import base64

load_dotenv()
app = FastAPI(title="Mentora AI Backend", version="1.0.0")

# --- CORS AYARLARI ---
# Flutter uygulamasının bu sunucuya erişebilmesi için gerekli izinleri veriyoruz.
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Geliştirme aşamasında tüm cihazlara izin veriyoruz
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# --- VERI MODELI ---
# Flutter'dan JSON olarak gelecek paketin yapısını doğruluyoruz.
class ChatRequest(BaseModel):
    message: str
    email: Optional[str] = "anonim_user"
    module_type: str = "chat"  # 'chat' (lokal) veya 'photo_solution' (bulut)


SYSTEM_PROMPT = """
Sen Mentora adlı yapay zekâ destekli akademik mentorsun.

Görevin yalnızca sorulara cevap vermek değil, öğrencinin konuyu gerçekten öğrenmesini sağlamaktır.

## Genel Kurallar

- Her zaman Türkçe cevap ver. Kullanıcı farklı bir dil isterse o dili kullan.
- Teknik olarak doğru bilgiler ver.
- Emin olmadığın bilgileri kesinmiş gibi söyleme.
- Kullanıcının seviyesine uygun anlatım yap.
- Gereksiz uzun cevaplar verme, ancak önemli noktaları atlama.
- Başlıklar ve maddeler kullanarak düzenli cevap oluştur.

## Eğitim Yaklaşımı

Her açıklamada mümkün olduğunca şu sırayı izle:

1. Kısa tanım
2. Temel mantık
3. Nasıl çalışır?
4. Basit örnek
5. Gerçek hayatta kullanım
6. Yaygın hatalar
7. Özet

## Kod Sorularında

- Çalışan örnek kod yaz.
- Kodu açıklayıcı yorumlarla destekle.
- Kodun mantığını anlat.
- Best Practices belirt.
- Alternatif çözümler varsa kısaca karşılaştır.

## Matematik ve Bilim Sorularında

- İşlem adımlarını tek tek göster.
- Formüllerin ne anlama geldiğini açıkla.
- Sonucu yorumla.
- Kullanıcı isterse kısa çözüm de sun.

## Yazılım Sorularında

- Önce kavramı açıkla.
- Sonra örnek ver.
- Gerekirse algoritmayı anlat.
- Performans ve kullanım senaryolarını belirt.

## Davranış

- Öğretici ol.
- Sabırlı ol.
- Öğrenciyi düşünmeye teşvik et.
- Gerektiğinde küçük ipuçları ver.
- Gerektiğinde mini ders şeklinde anlat.

Amacın, öğrencinin sadece cevabı almasını değil, konuyu anlayarak öğrenmesini sağlamaktır.
"""

@app.post("/api/chat")
async def chat_endpoint(request: ChatRequest):
    # --- 1. SENARYO: YAPAY ZEKÂ MENTOR (LOKAL LLM - OLLAMA) ---
    if request.module_type == "chat":
        try:
            # lokal Ollama sunucusuna istek atıyoruz
            async with httpx.AsyncClient() as client:
                ollama_response = await client.post(
                    "http://localhost:11434/api/generate",
                    json={
                        "model": "qwen2.5-coder:7b", # Bilgisayarına kuracağımız model adı
                        "prompt": f"{SYSTEM_PROMPT}\n\nÖğrencinin Sorusu: {request.message}",
                        "stream": False
                    },
                    timeout=30.0
                )
                
                if ollama_response.status_code == 200:
                    ai_text = ollama_response.json().get("response", "")
                    return {"response": ai_text}
                else:
                    raise HTTPException(status_code=500, detail="Lokal LLM sunucusu hata döndürdü.")
                    
        except httpx.RequestError:
            # Bilgisayarda henüz Ollama açık değilse çökmek yerine bu emniyet mesajını dönecek
            return {"response": "Lokal yapay zekâ motoruna (Ollama) bağlanılamadı, ancak FastAPI backend bağlantın başarıyla çalışıyor! 🚀"}
    elif request.module_type == "photo_solution":
        raise HTTPException(
            status_code=501,
            detail="photo_solution modu /api/chat üzerinde desteklenmiyor. Fotoğraf işleme için '/api/photo-solution' endpoint'ini kullanın."
        )
    else:
        raise HTTPException(status_code=400, detail="Geçersiz modül tipi.")


# --- 📸 FOTOĞRAFLI SORU ÇÖZÜMÜ TEST KAPISI ---
@app.post("/api/photo-solution")
async def photo_solution_endpoint(file: UploadFile = File(...)):
    try:
        # 1. Flutter'dan gelen fotoğrafı okuyoruz
        contents = await file.read()
        
        # 2. Fotoğrafı OpenRouter'ın kabul ettiği base64 formatına çeviriyoruz
        base64_image = base64.b64encode(contents).decode('utf-8')
        
        # 3. 🔑 OpenRouter API anahtarını ortam değişkeninden alıyoruz.
        OPENROUTER_API_KEY = os.environ.get("OPENROUTER_API_KEY")
        if OPENROUTER_API_KEY:
            OPENROUTER_API_KEY = OPENROUTER_API_KEY.strip()

        if not OPENROUTER_API_KEY:
            raise HTTPException(status_code=500, detail="OpenRouter API anahtarı sunucuda ayarlı değil. Lütfen OPENROUTER_API_KEY ortam değişkenini ayarlayın.")

        # 4. OpenRouter API'sine isteği atıyoruz
        headers = {
            "Authorization": f"Bearer {OPENROUTER_API_KEY}",
            "Content-Type": "application/json",
        }

        # Log whether auth header will be sent (do not print key)
        print(f"OpenRouter auth header present: { 'Authorization' in headers }")

        async with httpx.AsyncClient() as client:
            response = await client.post(
                url="https://openrouter.ai/api/v1/chat/completions",
                headers=headers,
                json={
                    "model": "google/gemini-3.1-flash-image",
                    "messages": [
                        {
                            "role": "user",
                            "content": [
                                {
                                    "type": "text",
                                    "text": (
                                        "Sen uzman bir akademik asistansın. Bu görseldeki soruyu/metni önce OCR ile tespit et. "
                                        "Ardından soruyu analiz ederek Türkçe olarak adım adım, anlaşılır bir şekilde çöz."
                                    )
                                },
                                {
                                    "type": "image_url",
                                    "image_url": {
                                        "url": f"data:image/jpeg;base64,{base64_image}"
                                    }
                                }
                            ]
                        }
                    ],
                    "temperature": 0.2,
                    "max_tokens": 1024
                },
                timeout=60.0
            )
            
            if response.status_code == 200:
                result_json = response.json()
                # Gemini'den gelen ham Markdown çözüm metni
                ai_markdown_text = result_json["choices"][0]["message"]["content"]
                
                # Flutter arayüzündeki tasarıma uygun şekilde listeye gönderiyoruz
                return {
                    "status": "success",
                    "solution_steps": [ai_markdown_text]
                }
            else:
                print(f"OpenRouter Hata Detayı: {response.text}")
                raise HTTPException(status_code=response.status_code, detail="OpenRouter API hata döndürdü.")
                
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Fotoğraf Gemini tarafından işlenirken hata oluştu: {str(e)}")


@app.get("/")
def read_root():
    return {"status": "Mentora Backend çalışıyor! 🚀"}


if __name__ == "__main__":
    import uvicorn
    uvicorn.run("main:app", host="0.0.0.0", port=8000, reload=True)