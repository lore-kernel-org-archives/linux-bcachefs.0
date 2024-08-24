Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com [209.85.167.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7433D320C
	for <linux-bcachefs@vger.kernel.org>; Sat, 24 Aug 2024 01:23:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724462603; cv=none; b=BfuCuY5x7vn8kb+5tHZkMTY4eGR6hiHTZ/lKlvwhhYkT+ufaq0GXx+bpGXdaegc3wv75K1aGPiXt0rXbpSN0lErh2I0slhW4Aa9jlClpILFtlm8goHJRCNUGtku3bK9xbwcuApCrt4sE3TK3ZseDxKpr5FbeDNLQXaJWHtVRMtw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724462603; c=relaxed/simple;
	bh=pFBmn1b8HGmxiNAzjHuI1t8iCFvWlQvq1ax4yTVhtWc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MeKApIuAr2hnkt4MuqdQofLCO17AHubfOm8TNHggG5mGD59+yQFqU14s1+hHE+cY23aTlpqZYWCS9J3n/8k0UD+MW88TRgHRtVV/T4/mTVCJ9PCaiVTAmZ5DapqXBjJP8rKXsj6nMdkzEffBjguuR/mPHqVWx7Y7xntn5dLUOrI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KDtEMk6n; arc=none smtp.client-ip=209.85.167.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KDtEMk6n"
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-533496017f8so3427371e87.0
        for <linux-bcachefs@vger.kernel.org>; Fri, 23 Aug 2024 18:23:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1724462599; x=1725067399; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=hS0PlIghB31D9UEMBMHujKkEVm4tXs1uqCiHkuDkoqU=;
        b=KDtEMk6nuI2F12uxqL2oxrKKtfpPaoT5FBEU6JIi99X+0H5aisnt2AYeFAgqiU5okV
         ASgMgLDDoRY9gUWzwRru0rCrTmRan0oq10Kj/kl2T9f/5JXlWccyfZwMvc4sLHxEuC1W
         vHnHM0INEQX4y9oLxyGy37u8OC7HRN1pqr7AE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724462599; x=1725067399;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hS0PlIghB31D9UEMBMHujKkEVm4tXs1uqCiHkuDkoqU=;
        b=FLET0pyNFiyol9MzJH9c7+2N1nQChndOMa3d8YIvQJJ+kM3XV661UpifiVnn7xX7fV
         lmbyjGS72A6GeVNsCrI0ofBMF603BWEU96aJVGA/JhM9AgVZZGtBqIKpR5P9+7GL25zN
         S1RHW0lXuiybLcTdFVYcVPeFcCc19RvAO08mXy67wYwAJxAOHgXB5mQ/3FCP9oYmna22
         dfPLG7+ywa/nd8cm7KIquWC3gWV5lPN462UaqoMfX23g0yrDclYRSiCKeQGjLxVSBk6S
         VgpdTINOeaY4vddVhuDeH5RMvqMpAkK98xuSxJMkhzo7X1hzes5svK88Fy4E1836+G/J
         3ung==
X-Gm-Message-State: AOJu0Yyx2meuvjOndJfXHge4SysuwCvN1pvAL1h1QW5WvUG2faWX/RYo
	KdTdmBdLwXYMyA54CxmbQ1E9BafCSS1p0GLa7FIpDR6pIL616ByJHMEzBk6sC0s7Z3JInVU5SXr
	VBfvq6A==
X-Google-Smtp-Source: AGHT+IGZkb2oMaeplAollXtUK89/bfp0dbp+6pTVHNxEma6eEGGs+sb+I1Gu6/HOQXlkjo9ErkcKXQ==
X-Received: by 2002:a05:6512:3d24:b0:52c:e3ad:3fbf with SMTP id 2adb3069b0e04-5343885f866mr2272036e87.42.1724462598686;
        Fri, 23 Aug 2024 18:23:18 -0700 (PDT)
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com. [209.85.208.49])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a868f2200f3sm331974966b.45.2024.08.23.18.23.17
        for <linux-bcachefs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Aug 2024 18:23:17 -0700 (PDT)
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-5bf01bdaff0so2910900a12.3
        for <linux-bcachefs@vger.kernel.org>; Fri, 23 Aug 2024 18:23:17 -0700 (PDT)
X-Received: by 2002:a05:6402:430c:b0:58b:585b:42a2 with SMTP id
 4fb4d7f45d1cf-5c0891a92a6mr2273293a12.38.1724462597330; Fri, 23 Aug 2024
 18:23:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <sctzes5z3s2zoadzldrpw3yfycauc4kpcsbpidjkrew5hkz7yf@eejp6nunfpin>
In-Reply-To: <sctzes5z3s2zoadzldrpw3yfycauc4kpcsbpidjkrew5hkz7yf@eejp6nunfpin>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 24 Aug 2024 09:23:00 +0800
X-Gmail-Original-Message-ID: <CAHk-=wj1Oo9-g-yuwWuHQZU8v=VAsBceWCRLhWxy7_-QnSa1Ng@mail.gmail.com>
Message-ID: <CAHk-=wj1Oo9-g-yuwWuHQZU8v=VAsBceWCRLhWxy7_-QnSa1Ng@mail.gmail.com>
Subject: Re: [GIT PULL] bcachefs fixes for 6.11-rc5
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Sat, 24 Aug 2024 at 02:54, Kent Overstreet <kent.overstreet@linux.dev> wrote:
>
> Hi Linus, big one this time...

Yeah, no, enough is enough. The last pull was already big.

This is too big, it touches non-bcachefs stuff, and it's not even
remotely some kind of regression.

At some point "fix something" just turns into development, and this is
that point.

Nobody sane uses bcachefs and expects it to be stable, so every single
user is an experimental site.

The bcachefs patches have become these kinds of "lots of development
during the release cycles rather than before it", to the point where
I'm starting to regret merging bcachefs.

If bcachefs can't work sanely within the normal upstream kernel
release schedule, maybe it shouldn't *be* in the normal upstream
kernel.

This is getting beyond ridiculous.

               Linus
