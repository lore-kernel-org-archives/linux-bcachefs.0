Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79466366
	for <linux-bcachefs@vger.kernel.org>; Sat, 15 Mar 2025 00:09:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741997359; cv=none; b=WtxRGW6jjNCPzGOl2RzpyrhOY9bpZRnbC6tSkteHjtk1Gu2BypzQjfKmriTWd6dfcYEa0lldAD2mYka4sFTy3/JmO2ngGGK4XXt3e8LCv78Be8qmnMvkIR/x9ES2Yhlv+YGfIsSUc6hiZKu73Of5xVf6eUPQs6tWK5SQ0CGTymg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741997359; c=relaxed/simple;
	bh=Tk7Mc/L0Uru7Lxwtwe8SxQqfPIRFT7uUArUqihjD+sY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NyY7GbOS2Q/swRDSCPfuynGV8FdKdP34C3vEHdQTWyTL2lXZ9VVqmengKTLTchHrYE/7VySND3gh54lctMM6eJNSE+EQM2Azx0uu4qVjIpnhV6bTvSp2HFHE2ro0lBXviZzpjiGSAycdbzzTeXst/4cN0Se88Vx9xzkaxMjWJvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Bt31D2hP; arc=none smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Bt31D2hP"
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-ac2ed007aacso526539766b.0
        for <linux-bcachefs@vger.kernel.org>; Fri, 14 Mar 2025 17:09:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1741997354; x=1742602154; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=e9b8jZBSOtn8NLuJNrlHfcMekSs0Id4ZVj4HYXH1a0c=;
        b=Bt31D2hPW4Mu0fwa1fKNyd3KkbpNRqU/ih+W5yen3fL5sLFqr/lT4M8eo9NIVh9DVf
         p4P/AgqcuDnQdHhBgQYCyVkS/bBDSq0idN00NsVrSckrgJh7hs734YjDf7M9QP3iEy8I
         kzCozFP6oSDYsPmFVLOySwacWmFtsCF219VfY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741997354; x=1742602154;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=e9b8jZBSOtn8NLuJNrlHfcMekSs0Id4ZVj4HYXH1a0c=;
        b=OFLIsrlmeK+nJYpiguHsS5Sqti/RD6jhio4jF9aQDFutaDrFSaBJWgLXB2nUKVe2JJ
         N0DHHBZtHdrTLTMbFRrpr7Gsz0cdeWZCe1NrxhNh1HAgJIw3eSavA876RoeWiK+EG+mI
         sCCTds97xFL3gmyRgeqIM9lpMGfG0sCTflj5SGBLohNLe9h/PdQLXtQFVAqJsLVr9nWL
         c0v+wJBopVyJZj3c9MRdh/WFVQpqFwEBnFcyx2gP2qYnQ61QypzPlNF8GfWBy6r1veKB
         J6jOTyd21Q0gfkv3NTuzhqJqiQdpTSJ2c0e4YmDWs951pkq/u6y/UCJcFvJPWjRME9Fu
         pzqQ==
X-Gm-Message-State: AOJu0YyUkfapAYM5Z6ag+im6lVuSsjSugqdkr+dss8RtfDA2Eej1cA5/
	l4tQ+hTFJdp9aevKPeSrzA/MV30fiFyz0ll14jz/WJ4ZphSSefvfVZI3v3kNKRnW6367iloxF80
	T9Hc=
X-Gm-Gg: ASbGncsIEx85g7SM/mkl10+zWkTVbq0JudxJBDGnMfJzZ6JWzh5VckTSHJEB8s/zITi
	TqbyQeg0LHdKbuggW/UjdwNA4R7TAPEKvX7oeq4ihqn3js2tfN/ni0zlSdrSTCQqaiqZKPVOUq4
	r1OFIUUwCYdzifrxpm+/wo5qKM4TYtJgmOOCyKgpgDrLJY2FN0kRR4szoEsQ97cQ573yAEJIfJ6
	w9jsA/8l3c+38ngxXS9ox2dMFhujYeWjWPFQWE6StiPogHF9I8kTpua1tz7grHGzuZ2ZoJE3Hnp
	sOdzulYgCEIe51U+Pr1Be7LtuixNNbOyFXnS2NcsLAN8FfSDetqdlnyBbiTYdadi33zyKsJPiph
	3woazXXPb65AsvtoziAo=
X-Google-Smtp-Source: AGHT+IGUkc7D2UO8MZ3SYwyUMu+hSFQcvU7Dc6Q8yebbST14jSAOgqLw/iyY9BNisTpsh7pklnw29w==
X-Received: by 2002:a17:907:d92:b0:ac2:d5e6:dea7 with SMTP id a640c23a62f3a-ac33017710cmr539628566b.13.1741997354461;
        Fri, 14 Mar 2025 17:09:14 -0700 (PDT)
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com. [209.85.208.46])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ac314a4094dsm287565766b.126.2025.03.14.17.09.12
        for <linux-bcachefs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Mar 2025 17:09:13 -0700 (PDT)
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-5e6167d0536so4901505a12.1
        for <linux-bcachefs@vger.kernel.org>; Fri, 14 Mar 2025 17:09:12 -0700 (PDT)
X-Received: by 2002:a05:6402:5108:b0:5e5:e836:71f3 with SMTP id
 4fb4d7f45d1cf-5e8a051bae9mr4316872a12.29.1741997352300; Fri, 14 Mar 2025
 17:09:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <r6wusnyqqcmnamampwguyscjpvgwrnwhipsglryaltnofmmkf3@7b4fixf5q2qg>
In-Reply-To: <r6wusnyqqcmnamampwguyscjpvgwrnwhipsglryaltnofmmkf3@7b4fixf5q2qg>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 14 Mar 2025 14:08:56 -1000
X-Gmail-Original-Message-ID: <CAHk-=whyp8+TivigcJb_UxARH_QBACKgF9_38G1r0jq9c07Dsw@mail.gmail.com>
X-Gm-Features: AQ5f1JqaOeDi8cKfB_KrAPZAzmHOiAwu-CnE9WD7xJCYkUzwcxZCzABbEd2IyeM
Message-ID: <CAHk-=whyp8+TivigcJb_UxARH_QBACKgF9_38G1r0jq9c07Dsw@mail.gmail.com>
Subject: Re: [GIT PULL] bcachefs hotfixes for 6.14-rc7 v2...
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Fri, 14 Mar 2025 at 14:03, Kent Overstreet <kent.overstreet@linux.dev> wrote:
>
> You'll be wanting this one too...

Bah. I had already pulled the first version earlier.

I'll do another pull.

              Linus
