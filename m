Received: from mail-lj1-f171.google.com (mail-lj1-f171.google.com [209.85.208.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A93CEB64A
	for <linux-bcachefs@vger.kernel.org>; Sun, 20 Oct 2024 19:10:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729451420; cv=none; b=qvaDDWbcgiLom9/G84C8P3i0MjpPkcaqRNTjsfhFXe8S1XQsFcUAU9LUZAGhKxPVUNZyS53hGR3nH6uV0fETLLTNnmOz6MvfPNF0SiJIOAgMvDbpa4scB8qgigLUTD5iLHUOdxgOmvzE/liYEHUDCny5JMfNTsk9CkKguz4SdaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729451420; c=relaxed/simple;
	bh=y4zRQ2QU9gaxktZ2MgGBTSYjfl5b6quTDHqrQ54i+oE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ofjxX64UgkCA6fuPTolDnX/BOC+u5oF8hBRjvIQWxurfiJ0XSkbp9AArTj8o7kgi2H2wzGlJ00eJblkrEnCbi9u8KVy51gXC5SGu2DixJvUQibG9ACSyFY3haKtD5jUm0Nq7XRMFnyvCNWOl/e/V3RtEOVYQXLVLT2nanAFYyAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LbP7szwU; arc=none smtp.client-ip=209.85.208.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LbP7szwU"
Received: by mail-lj1-f171.google.com with SMTP id 38308e7fff4ca-2fb518014b9so31652901fa.3
        for <linux-bcachefs@vger.kernel.org>; Sun, 20 Oct 2024 12:10:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1729451416; x=1730056216; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=6BMcJUt36FUv66J+8VpViPdkMksRTeOdm/DICRqmKlg=;
        b=LbP7szwU/MqRYCytlmqWo03ncTZ4uOInE21LKboz84xUMB0GZV5saIHHScfZ2eDxdV
         fntIkomhq54Uru6p+RkJm0xNGOpkAT0Ip15e8JnzvtUclwUe4HsysNSGNB6ufLdXdzf5
         /obx900DfHpNpYmFlvCzNzKPLOWqen70LgeBU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729451416; x=1730056216;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6BMcJUt36FUv66J+8VpViPdkMksRTeOdm/DICRqmKlg=;
        b=qq5iQC2xD4qJOW3U2UpyfxyI5rkDHwhxLyqVPrk2W1BgVFRaFvEWN811QbgQSbtSpI
         qrgd1xgjm+ljO8hXFktJQJ1zM5M6q3m3zI6ft0noTTaEARfZrHkOuxGiNHhvQ8HS/Sr/
         h0tt5jVYdjxMtQggbQdhOMwl4YdXJsdRs9qoVIYBXki3tKMdbsQXBuRmG+bpmD2vC/TZ
         rilzUL07DE0byYfJP7IzYqmXqHjn0bk8bHTtYcz007eoLC8gx1XVw4+RT/56xGFdBSaP
         nRbaBa85DbLIjXLxMHmZCHVwLK8Zi76WNxDO+1KeStJRbahVF04L5sB78AIlIxbP+MBl
         B1Sg==
X-Forwarded-Encrypted: i=1; AJvYcCXi/HDCLSuDbmQPlWdOn5BWkfr4Mzzxf9pDa0sRtGsReqoQ+AwBqsxwuaZJcjrPICVElA7Nu2HA/nL4RbMeow==@vger.kernel.org
X-Gm-Message-State: AOJu0YxwJLb4SgMUxdppd4XzMc8NkjrWz89ynWA3+srWptvf/5McTTQi
	cIy44xcfD9ViCw1C4Yc9kM7y+fprsNNsDx+Ice8XaR97totzHch3Lqm1h1L6VTiuGfh/5AcV2Xz
	pwgzR/A==
X-Google-Smtp-Source: AGHT+IHlVfavwbQm+FWFqxPAC4z1KkiNURJPM6oXnIwHAIDjndT3PJpishR8lvKVoTUupYMuMxNHCQ==
X-Received: by 2002:a05:6512:3989:b0:539:d9b8:284e with SMTP id 2adb3069b0e04-53a154cea95mr3956609e87.50.1729451416273;
        Sun, 20 Oct 2024 12:10:16 -0700 (PDT)
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com. [209.85.218.45])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a9a912edfe1sm117547466b.53.2024.10.20.12.10.15
        for <linux-bcachefs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 20 Oct 2024 12:10:15 -0700 (PDT)
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-a9a5b2f2026so421198466b.2
        for <linux-bcachefs@vger.kernel.org>; Sun, 20 Oct 2024 12:10:15 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUdbvCnivvAE+sKc7ayPh00HB1p/D5mM1ODPeV3OhuMAeBc/fM/Ld3mbItIy/FmKTNKZpUJD+mzBDLzuJvxVg==@vger.kernel.org
X-Received: by 2002:a17:906:c150:b0:a99:e600:7e06 with SMTP id
 a640c23a62f3a-a9a69c92034mr801740166b.51.1729451414686; Sun, 20 Oct 2024
 12:10:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241019210037.146825-1-kent.overstreet@linux.dev>
 <90bc0794-4cab-415f-a442-4af85a32eed8@lucifer.local> <ucbcmk4kr7tbvj6uqnjke5662kerawbr4ghtlbw4zim7mdm3fg@vjawfne5rdkp>
 <ebe58a08-2371-403c-a0d7-6280160b6848@lucifer.local> <zfr4sh3wtzi4viladlgwyon6voqhcj5fe3fv2nc3hqyyxdw5wd@onyj3r2m3usz>
 <CAHk-=wi=PrbZnwnvhKEF6UUQNCZdNsUbr+hk-jOWGr-q4Mmz=Q@mail.gmail.com>
 <m46mlvv57oypstekojhkdwpts6mi4r63l4kugs4lpry3d2r7dq@kbmied6nzsc3> <CAHk-=wg8iZWDbX_MAujGtqHJYQneKBwDJnVAY94siNr1gLmtaA@mail.gmail.com>
In-Reply-To: <CAHk-=wg8iZWDbX_MAujGtqHJYQneKBwDJnVAY94siNr1gLmtaA@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 20 Oct 2024 12:09:58 -0700
X-Gmail-Original-Message-ID: <CAHk-=wiW_QZ9VS3Ho2Ff8ZDp-T6SomDFrVPWG3abs45LMZpxZQ@mail.gmail.com>
Message-ID: <CAHk-=wiW_QZ9VS3Ho2Ff8ZDp-T6SomDFrVPWG3abs45LMZpxZQ@mail.gmail.com>
Subject: Re: [PATCH] mm: Drop INT_MAX limit from kvmalloc()
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, linux-bcachefs@vger.kernel.org, 
	linux-mm@kvack.org, Vlastimil Babka <vbabka@suse.cz>, 
	Andrew Morton <akpm@linux-foundation.org>, Uladzislau Rezki <urezki@gmail.com>, 
	Christoph Hellwig <hch@infradead.org>
Content-Type: text/plain; charset="UTF-8"

On Sun, 20 Oct 2024 at 12:09, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> How about you limit the amount of memory you use in the first place instead?

.. and to clarify: we're not making other parts of the kernel less
robust because *you* are doing something stupid and odd.

              Linus
