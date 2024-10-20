Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABAAE45025
	for <linux-bcachefs@vger.kernel.org>; Sun, 20 Oct 2024 21:22:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729459334; cv=none; b=VY06IrlWC1sX79T0XgLRtjLslHVmLbK3X1EdC7BpUpThCuQPUfhwPV731htsssbgZfGUePguEe7xznFxdP1VCVc4lYDkKnZkLaS8Z52tCUHPvnaw0gRyC8H0FXZvf8k0u32zbi3j7k/AnnnGvlYbaTuwAnSHPTZRatBrFVB6SBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729459334; c=relaxed/simple;
	bh=kHHkMfTdk1yxBi9GFJOJUHNE5epdaEif9Xrygyvebq4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Qzj9kULeojVqk4NmorNleRRkdOD02HA1d2JCcNk6QvE4SBaAE3dixxzL+7BLaLj6fFji6zRwxeF7R582xYASkpKzN2SoDR7l1t14YzzGCFk3BKQzu6CbgQvoueFmdOg1LTzKxMZFaY73+dpzhAjYlErf/E/GWtUzL0VHwEeec7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hRCggkhv; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hRCggkhv"
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-5c962c3e97dso4541246a12.0
        for <linux-bcachefs@vger.kernel.org>; Sun, 20 Oct 2024 14:22:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1729459330; x=1730064130; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=PS+p0YlMCofx0chL+b7QCQft5IdeCqrROiwD8Jc4Jq0=;
        b=hRCggkhve8zG9oqSXBXhDRcWEYK85BuXdSYXsGvKRYPzmYh24WURpMDjDoATg2+p4k
         AauG++n4KlkJyDuO3eDpwP0D63jOHo2+xTRLASQv2k7jzQFp5sapuCAnJzfWQbLyWsex
         YJ+cy/ihe2Ba326JvxpixRO3LgRMxfN6aT/3g=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729459330; x=1730064130;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PS+p0YlMCofx0chL+b7QCQft5IdeCqrROiwD8Jc4Jq0=;
        b=kUeDTWp8nbcrHSA2oPRDkL4qvtDFeEaa92SsPQuRl6StWOyLqxt+CtjBuhSPWhxebg
         8StputurcZyxLDjxuKpSisfpXJ8TYsZG5uFAriAVGRCQ/ysCsn3fNEoiTJuQobEZ15Qh
         cHVvRGVHkAEhmhuTUj0jFSSA/erE5VyMqAa715D4kf8UKx8H5wjlVK3BGtCPJhzYHaah
         iEz06DS9WNFYdoc+uFL2akhbi6ffXvnz5YGZMbrOGJwjDVzUimwHJ464X6MLv0V/NTTm
         pzWn1IftQvc1Mf9/WKVmNQqjew422/RrfHLeGq9opctXhfbAgfKAdr78LQI/QNl6wp6i
         +o9A==
X-Forwarded-Encrypted: i=1; AJvYcCVCzZ1J/tFfAT+GIsOkQNpowyzw0lbzQCGGICYk/nZcRTi1N16Kj0mGxoFmbCdl9aRtB8grAgZtUTHzspkTeQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YwWjJrA28IW37z6uFwHOv3dy8vOlkkPJ1CrPLrZ81tlQsNAqq7a
	woLmPIrhTPL6dG16/XyiktpSwQGGQ/1TRruyueQMxB+zCNFXMQD6AuHJFDM2XKJiat4UWPKRwuk
	N5RTvBQ==
X-Google-Smtp-Source: AGHT+IGWcapcm28AjGpKfN9OtGHaE7OjB/0571hDZ5/7ryN7/NnMeNMYMkSVsWWmvnsmISo5O/v3hA==
X-Received: by 2002:a05:6402:13ce:b0:5cb:6ca4:f552 with SMTP id 4fb4d7f45d1cf-5cb6ca4f60dmr661008a12.35.1729459329706;
        Sun, 20 Oct 2024 14:22:09 -0700 (PDT)
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com. [209.85.218.51])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5cb66a653f5sm1247525a12.26.2024.10.20.14.22.07
        for <linux-bcachefs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 20 Oct 2024 14:22:08 -0700 (PDT)
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-a9932aa108cso568206466b.2
        for <linux-bcachefs@vger.kernel.org>; Sun, 20 Oct 2024 14:22:07 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWtwhN198PQ4eDSMFqEbIxZ1CNVCLOB0zRkHHuyiDfM1ZCcxBUBs8LHO+lP5OFtWN91+jWcMPhn3uyFVe2h1A==@vger.kernel.org
X-Received: by 2002:a17:907:930b:b0:a9a:d2a:be39 with SMTP id
 a640c23a62f3a-a9a69a760ecmr1013593466b.25.1729459327586; Sun, 20 Oct 2024
 14:22:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <90bc0794-4cab-415f-a442-4af85a32eed8@lucifer.local>
 <ucbcmk4kr7tbvj6uqnjke5662kerawbr4ghtlbw4zim7mdm3fg@vjawfne5rdkp>
 <ebe58a08-2371-403c-a0d7-6280160b6848@lucifer.local> <zfr4sh3wtzi4viladlgwyon6voqhcj5fe3fv2nc3hqyyxdw5wd@onyj3r2m3usz>
 <CAHk-=wi=PrbZnwnvhKEF6UUQNCZdNsUbr+hk-jOWGr-q4Mmz=Q@mail.gmail.com>
 <m46mlvv57oypstekojhkdwpts6mi4r63l4kugs4lpry3d2r7dq@kbmied6nzsc3>
 <CAHk-=wg8iZWDbX_MAujGtqHJYQneKBwDJnVAY94siNr1gLmtaA@mail.gmail.com>
 <CAHk-=wiW_QZ9VS3Ho2Ff8ZDp-T6SomDFrVPWG3abs45LMZpxZQ@mail.gmail.com>
 <6eo3gekf6twbnzhpsi2emz2s6sgtof6iba2rvbor7himmejoq5@qbfwtpbpvqoe>
 <CAHk-=wga3FXReWVhU2eid8+sXhBF1QgP1iMJu1jnSX6fapoyXQ@mail.gmail.com>
 <ikaf72w2oap3crjrybbd5jp267slnb7dygz4m62dfw3edu2ppj@f7dv2qdx3yga> <CAHk-=wggLED-UmxS0gXrtOXBVWexCkyudYCr5zXNh8p5PB9bng@mail.gmail.com>
In-Reply-To: <CAHk-=wggLED-UmxS0gXrtOXBVWexCkyudYCr5zXNh8p5PB9bng@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 20 Oct 2024 14:21:50 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjQDCtzBUiRPuKfyjGFiR9JZi82ENyzdvKei4W3pxt=tA@mail.gmail.com>
Message-ID: <CAHk-=wjQDCtzBUiRPuKfyjGFiR9JZi82ENyzdvKei4W3pxt=tA@mail.gmail.com>
Subject: Re: [PATCH] mm: Drop INT_MAX limit from kvmalloc()
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, linux-bcachefs@vger.kernel.org, 
	linux-mm@kvack.org, Vlastimil Babka <vbabka@suse.cz>, 
	Andrew Morton <akpm@linux-foundation.org>, Uladzislau Rezki <urezki@gmail.com>, 
	Christoph Hellwig <hch@infradead.org>
Content-Type: text/plain; charset="UTF-8"

On Sun, 20 Oct 2024 at 13:54, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> On Sun, 20 Oct 2024 at 13:30, Kent Overstreet <kent.overstreet@linux.dev> wrote:
> >
> > Latency for journal replay?
>
> No, latency for the journaling itself.

Side note: latency of the journal replay can actually be quite
critical indeed for any "five nines" operation, and big journals are
not necessarily a good idea for that reason.

There's a very real reason many places don't use filesystems that do
fsck any more.

But yes, it's a different issue from the runtime performance / latency side.

             Linus
