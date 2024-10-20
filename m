Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5249C2C6
	for <linux-bcachefs@vger.kernel.org>; Sun, 20 Oct 2024 20:54:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729457678; cv=none; b=aDRttOTMvF4Km2O839ZA9PMNT0b6mXs+rvnlgF+Sq2GTO4Tuiact2ZNn4Y1mIzCv9zzfQ3CopDtlcQ9ojGp72q7m014H2EsnM/1WllFfEkBzwjLpwIhSP+GKwQ1KBriWAEvIHBK+j331m+++6UuD4LHoLFR8Qqc73JExMLVFJTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729457678; c=relaxed/simple;
	bh=h4a8l3tRxv/g7GRj+Tqjyjb6C4KHidGQCQrE4wBQ1TY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rS2NMs8IG2uXx6+LT1C7bo78Kezhvzp/EYdTsNG3b6QU929YEXHJSq/SC/SbvE75XRWgJpOmDDB97aE0t61j/hEfm1JZhmmk4ge13Yj72NB0ulMzitic3DKEDSpltxc2ZqNAMqyRtzWQemy3KCuuVNahEHanVUH2R6dO5GCVaBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RIvVYZQb; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RIvVYZQb"
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-5c948c41edeso4377270a12.1
        for <linux-bcachefs@vger.kernel.org>; Sun, 20 Oct 2024 13:54:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1729457675; x=1730062475; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=aJEOlGi6/NlpOBfgvKHdSVSVCJV506MrOJiwvsRFLeE=;
        b=RIvVYZQb3zNJfDbx5zZ75CEAkhwPyrPGBpiCY1vAqySK2P81LXHdsPjkJxu5nP0DrR
         PuYTPKkvEOPRLRvPK7msvBksZo4PGbHhca6qXsLzyyPQZOaKhGAGHEuMRL29RTzJb6X9
         edSyfcjXyewdB+FmBCmdx0XZGGkbU9g2p/Opk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729457675; x=1730062475;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aJEOlGi6/NlpOBfgvKHdSVSVCJV506MrOJiwvsRFLeE=;
        b=KbM65KfXhsDG62CCrE6XDRBobSHh1owAAXpQMUea/CGqwB013cnscO0oR9klS66yyF
         KcZQVgJ7shboJo9F+KoV4uWJoHvRjuRhUXtr2JS92SmciCKM8cBGR8wuSeRyu5mGGFXU
         J+w4LqtjtPcpo0vyW1wlUY8csjdjXoAxfq1ozEfX82LbKsRERGBIRKn25Hz3FlYBjCxQ
         4SEQ4VVFffhPakKO9pWWnOsH4thSJAxATsy6iNLWrh8FCmC58PWEhmjXOOx0F7h3dfYP
         I1DA8z2cp8UjLH6dGFAMOcWH6zp6M7Bgq6lg6NVTZgQ3B/CpLklE9FSJ5gJB753CSjPA
         l9OA==
X-Forwarded-Encrypted: i=1; AJvYcCUwB9WJSQ8N5E5gFRo7ldkaS9vCPHGsQh8oqUCncCZOXBjTZbgum9nJYRGc1jMIieDDUN9C9dvQEHtuVefkvw==@vger.kernel.org
X-Gm-Message-State: AOJu0YwWjOptcM0K/ySO//S7wVPKbrebCdfQJbTD2+oRdsGjAHbP7j9m
	zSsLZkAq2CfMR+Y0NHlifljpZNGVlIBVEqVm1YFMJA8kqh5ZWDVl6ZTSwLy408Y8FcdBnmXbxYn
	j6y/rmQ==
X-Google-Smtp-Source: AGHT+IGXJJNO7g1sPMa2ob3z+aKXQ+TMqLYskjQd5xOZSEc1Z8rUHA+Ir1EGkJ2Jmm4Usjj8G22AuQ==
X-Received: by 2002:a17:907:944a:b0:a99:ee1c:f62f with SMTP id a640c23a62f3a-a9a69ba6d2fmr1019952266b.34.1729457674664;
        Sun, 20 Oct 2024 13:54:34 -0700 (PDT)
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com. [209.85.218.53])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a9a9101f9ffsm126705766b.0.2024.10.20.13.54.33
        for <linux-bcachefs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 20 Oct 2024 13:54:33 -0700 (PDT)
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-a9a0472306cso506557366b.3
        for <linux-bcachefs@vger.kernel.org>; Sun, 20 Oct 2024 13:54:33 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCXZ+zae9VKziu5wFDXo64OhJad91yCL/wH9pu9DbFsPyUhPWRxEcIA+VzJQch+ovLJMcVHqu2BH9PpFrjDCFQ==@vger.kernel.org
X-Received: by 2002:a17:907:3f23:b0:a99:e4db:4909 with SMTP id
 a640c23a62f3a-a9a69a746e7mr1060657266b.15.1729457673433; Sun, 20 Oct 2024
 13:54:33 -0700 (PDT)
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
 <CAHk-=wga3FXReWVhU2eid8+sXhBF1QgP1iMJu1jnSX6fapoyXQ@mail.gmail.com> <ikaf72w2oap3crjrybbd5jp267slnb7dygz4m62dfw3edu2ppj@f7dv2qdx3yga>
In-Reply-To: <ikaf72w2oap3crjrybbd5jp267slnb7dygz4m62dfw3edu2ppj@f7dv2qdx3yga>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 20 Oct 2024 13:54:17 -0700
X-Gmail-Original-Message-ID: <CAHk-=wggLED-UmxS0gXrtOXBVWexCkyudYCr5zXNh8p5PB9bng@mail.gmail.com>
Message-ID: <CAHk-=wggLED-UmxS0gXrtOXBVWexCkyudYCr5zXNh8p5PB9bng@mail.gmail.com>
Subject: Re: [PATCH] mm: Drop INT_MAX limit from kvmalloc()
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, linux-bcachefs@vger.kernel.org, 
	linux-mm@kvack.org, Vlastimil Babka <vbabka@suse.cz>, 
	Andrew Morton <akpm@linux-foundation.org>, Uladzislau Rezki <urezki@gmail.com>, 
	Christoph Hellwig <hch@infradead.org>
Content-Type: text/plain; charset="UTF-8"

On Sun, 20 Oct 2024 at 13:30, Kent Overstreet <kent.overstreet@linux.dev> wrote:
>
> Latency for journal replay?

No, latency for the journaling itself.

You're the one who claimed that a 2G cap on just the *index* to the
journal would be an "artificial cap on performance" when I suggested
just limiting the amount of memory you use on the journaling.

Other filesystems happily limit the amount of dirty data because of
latency concerns. And yes, it shows in benchmarks, where the
difference between having huge amounts of data pending in memory and
actually writing it back in a timely manner can be a noticeable
performance penalty.

It's still a good idea.

             Linus
