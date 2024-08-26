Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52766196D98
	for <linux-bcachefs@vger.kernel.org>; Mon, 26 Aug 2024 16:54:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724691248; cv=none; b=cSR9v8Y4tj/txPFzB3ktB7VEa/aI/hD3yDRXt7maI1ernCRNqOWyUSivLpPzwE55eWYih4yJWO3e1slgsodnFWESOLj1/nE+LNZIFoFkxmUzHKuSOMJoJWjNLJS1Zxz3JXHXeI/eer2ydsjwGbRXeq+befyrpJmn3WnDNBkR7v0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724691248; c=relaxed/simple;
	bh=SrrYymcdbDLizvS79/RRUElJG4frmyAuzrjQG6kpUYg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NwCx4seQpkbyE8MXNJLS24Mv9dCGAP2vfHBIqF//Zd1CSm2LgJfFPJeY03GwnyJ8JNKWyuBnYVFDTT/vIGHazL2py22ykHq+7y+4gl90s7T5pigCk9SrYpSglXVHtj0t4ei7eE69yoeG0KR2odZYCNstYpwWi2bli6bjUGpAhZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=NqB7pnFI; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="NqB7pnFI"
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-a83562f9be9so413656066b.0
        for <linux-bcachefs@vger.kernel.org>; Mon, 26 Aug 2024 09:54:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1724691244; x=1725296044; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=AuNkNTNASSkVHyZwptKwTsvU1aOshMXolrmNLp6jKyI=;
        b=NqB7pnFInPxLsopP4yeDHM3L5xm7QFZkJ5UteTNfoADN7u95ugBbLEbUGFXYiGYdYg
         +as1d0i1H2RIVsr8P2YrX6AR0+FEBLrm87xN1l2XGJU1N1lN4j1CbGXih/ZuyybGYiGT
         vo1Uv3Hl1eV+Z+vFBxQ4hQ7dxalGJZJg3qIM3PlrHWuSGV9HljD/S+/8A44EhvhZO+ue
         YlBOtqW5kbAkqPoP050njWJgOv+bmgDbD1YiBLvFu7EuE5QwDaLrCYm9s2Ob11g3GKb7
         AsIRKBui3RFELkLkrr/rs1QAq3iIX7D8WGiVdCdxDLm7e3/n9XClRkZriSe15u+PSwIR
         291g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724691244; x=1725296044;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AuNkNTNASSkVHyZwptKwTsvU1aOshMXolrmNLp6jKyI=;
        b=hEKslrbG9qizBO3iviBCBotCO6BpgQGlTyBRKkFRoqhpvnN9LeWKlBhen1ST464IKt
         nTwRqMOQCg5cf91+I5q6yqcNpUQ7OP6EfGaDXeWMQ/vpR3ZSGb4FNwlWuNtSeS9kLQgu
         416bWa/YaXJMNd3s6DcIcwhLkgK9s/XwI3uHW1xdjQDJGXK5Gs/Nsi0Wk6aEaoYWDHun
         cm4Vy0ZSVtzRKTyIzw4dsfiD1mLHQfYDh5LC42yneJQbDdnDYAw3sfCPOFr/mH122zXW
         geG+imGe2PtGFbe6lDJoutBRai5+OfezIMIeW869ZP2wuyqM81+PSJXfm1+wODRa2Ikz
         bklw==
X-Forwarded-Encrypted: i=1; AJvYcCW+R8KBTMXEHzVw7C+vIzsGAwz9BlkIeVScR5oAhU3PY221CFyfwjF4VNDeLu7l16vUc6z6pzteMBfuRcgIvw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yyxts+qpO1MTTLcZS267GlpciIjkrGa/NQRH2duZsBxPhWUsU9d
	EDLznWIaIJdPKdQ5Ci8BEHw9usR2LqaVUHaxXZVgU4tn/bIZD3/4eQD+W3qKbnE=
X-Google-Smtp-Source: AGHT+IGqicfaj3+0I5vKnr31dtF3PG61H07IprF3n2t7ZPxM1+pfgLfSyChrmgA9n5aCTBY9B2eIuA==
X-Received: by 2002:a17:907:2d0a:b0:a77:f2c5:84b3 with SMTP id a640c23a62f3a-a86a5199093mr691568166b.22.1724691243592;
        Mon, 26 Aug 2024 09:54:03 -0700 (PDT)
Received: from localhost (109-81-92-122.rct.o2.cz. [109.81.92.122])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a868f2e66eesm687492566b.97.2024.08.26.09.54.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Aug 2024 09:54:03 -0700 (PDT)
Date: Mon, 26 Aug 2024 18:54:02 +0200
From: Michal Hocko <mhocko@suse.com>
To: Yafang Shao <laoar.shao@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Christoph Hellwig <hch@lst.de>,
	Kent Overstreet <kent.overstreet@linux.dev>, jack@suse.cz,
	Christian Brauner <brauner@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>,
	"Serge E. Hallyn" <serge@hallyn.com>, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, linux-bcachefs@vger.kernel.org,
	linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] mm: drop PF_MEMALLOC_NORECLAIM
Message-ID: <ZsyzKmbmNs06Zrt9@tiehlicka>
References: <20240826085347.1152675-1-mhocko@kernel.org>
 <20240826085347.1152675-3-mhocko@kernel.org>
 <CALOAHbAU6XwN9ti0A1_KywpPqzgKxykWTxHYcYPQOywJo7FePQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALOAHbAU6XwN9ti0A1_KywpPqzgKxykWTxHYcYPQOywJo7FePQ@mail.gmail.com>

On Mon 26-08-24 21:48:34, Yafang Shao wrote:
> On Mon, Aug 26, 2024 at 4:53 PM Michal Hocko <mhocko@kernel.org> wrote:
> >
> > From: Michal Hocko <mhocko@suse.com>
> >
> > There is no existing user of the flag and the flag is dangerous because
> > a nested allocation context can use GFP_NOFAIL which could cause
> > unexpected failure. Such a code would be hard to maintain because it
> > could be deeper in the call chain.
> >
> > PF_MEMALLOC_NORECLAIM has been added even when it was pointed out [1]
> > that such a allocation contex is inherently unsafe if the context
> > doesn't fully control all allocations called from this context.
> >
> > [1] https://lore.kernel.org/all/ZcM0xtlKbAOFjv5n@tiehlicka/
> >
> > Signed-off-by: Michal Hocko <mhocko@suse.com>
> > ---
> >  include/linux/sched.h    | 1 -
> >  include/linux/sched/mm.h | 7 ++-----
> >  2 files changed, 2 insertions(+), 6 deletions(-)
> >
> > diff --git a/include/linux/sched.h b/include/linux/sched.h
> > index f8d150343d42..72dad3a6317a 100644
> > --- a/include/linux/sched.h
> > +++ b/include/linux/sched.h
> > @@ -1657,7 +1657,6 @@ extern struct pid *cad_pid;
> >                                                  * I am cleaning dirty pages from some other bdi. */
> >  #define PF_KTHREAD             0x00200000      /* I am a kernel thread */
> >  #define PF_RANDOMIZE           0x00400000      /* Randomize virtual address space */
> > -#define PF_MEMALLOC_NORECLAIM  0x00800000      /* All allocation requests will clear __GFP_DIRECT_RECLAIM */
> 
> To maintain consistency with the other unused bits, it would be better
> to define PF__HOLE__00800000 instead.

OK

-- 
Michal Hocko
SUSE Labs
