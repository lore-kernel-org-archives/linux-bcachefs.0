Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65A541A4B81
	for <linux-bcachefs@vger.kernel.org>; Thu, 29 Aug 2024 13:12:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724937145; cv=none; b=gGbRVmgSBvupjPA6/c40WnRZOo8SKcRds7uJvLHXBp8Gq8IfCxtDDIUIEUVe9V25gJLTCgvh+mjOO3jFT9f63cK/wn7l+/tF+7WAHoBKed5VvscV33M3SnM1YnSqsTihnx3NGz0VC41psuXOJrh/enVtis9WBTkiEtJqoiHPe7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724937145; c=relaxed/simple;
	bh=A/ukJ4jBr8jJQwS6YKUvYcuWgw8ce4anDS07GtBUeqA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=t4SN6BosRO/kRyFxpOZTQWAeHBhEJqHbj30ojeCY7RYvo0IQtWuM/cN/MQyUujex1xr7Eg+mVqAnMb43mksEBDGgmLEh0dn7Wfb6mutJCheEIUr9JZ3c6cunCxZ1XYwOQEd/KVHy/Uty1wpDGARAed+NInzH06gz1VwB90wj/ik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=cC025rxp; arc=none smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="cC025rxp"
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-2d439572aeaso476467a91.1
        for <linux-bcachefs@vger.kernel.org>; Thu, 29 Aug 2024 06:12:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1724937143; x=1725541943; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=8qX/f6dofDtGfqoUjh7wF0DGgkcB4Ol606CTys8bLCc=;
        b=cC025rxp2s0f9GU8p4vFM6gK/4CEuAH6aoyzZVG8TzaHQKelvBm+U9hT0BRgzwgDR+
         kABSDebTyiEq/IJ11jRgRMkAdcrQmWqqTKbHsLB+XyWVgv3aXDNwND1ac5zT49GaBQuy
         We/n4Is49FIPa2ssOupls8mNrbPnHleE+x9mLiZLokPnEDhe7PtVSRycuXJ7noZrlLMl
         DhM5WSSCbQZN4QsYUVw4ELdyVw0v9f+3TcrcQAbz1tg35HcgpY/XHlUebzmx2sO7uGjX
         IwpeXFw3oHa77o5TM3pEqgZvJaug/Km4747KQweRsFHIFJ5sFLqVG5ii0gLQxQidO2B/
         NIow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724937143; x=1725541943;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8qX/f6dofDtGfqoUjh7wF0DGgkcB4Ol606CTys8bLCc=;
        b=Tm+EG8pFWWOjX1ZiNT29QBj/XcRtuo0Y/vrZOwufP+uQishLOs4TLc74EvkszAHj9B
         FM34e2eNDZj7B9N6u1igLo/wvHxfP09FGZW5HHZJnGTxCjTXvI25EQ0OxvSF7btLOV5c
         MCa+xkgeMJpgDKolEEF3RyyBHmCrJrtrDQLG8rfwWrryrhsi8DjoxhtIz3tqDfOA/XW2
         5OUFjZ6TsaHeiQakPHyXjrsWVJrXYR6UWzvu8bqHVamcb2ZGIE9JdJAITHRRoZyWUrDH
         n+c9CZOSQ6xLgekw5mG4Ol3a/qEO1EZf0w7O3fNbjL/nm/tEQ5RLIPklm8h0TDJZd0p/
         Jq1g==
X-Forwarded-Encrypted: i=1; AJvYcCWej1I0rU2eVJ87MEVAwl++Nd4bbMcSUtQHOeykBz1aU64m5lonSr9yo0wt0k4+7+p32JQvdV6jM1r3Tr6uew==@vger.kernel.org
X-Gm-Message-State: AOJu0YwSFk9+6GAlcMIBSC3K1RqJhxwCIEjs4UBj/yqBzIXcpn5ZDT4Z
	m5grrl291acXvTgG2EIGugUHOS2DsaBwjuf+A2eVEhn865f0vsS0PsdReIeMBQs=
X-Google-Smtp-Source: AGHT+IE5og1QyFjbYL+fjlxeemY0chdVMvPBO6yd0H47y0vJ8/ygu0YjmhWpP08sTZ8j5BBHBY/dlw==
X-Received: by 2002:a17:90b:c12:b0:2cb:5829:a491 with SMTP id 98e67ed59e1d1-2d85c7d28c3mr2403333a91.20.1724937142595;
        Thu, 29 Aug 2024 06:12:22 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-0-65.pa.nsw.optusnet.com.au. [49.179.0.65])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20515542376sm10955575ad.204.2024.08.29.06.12.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Aug 2024 06:12:22 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1sjewk-00GwzF-1j;
	Thu, 29 Aug 2024 23:12:18 +1000
Date: Thu, 29 Aug 2024 23:12:18 +1000
From: Dave Chinner <david@fromorbit.com>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Michal Hocko <mhocko@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Hellwig <hch@lst.de>, Yafang Shao <laoar.shao@gmail.com>,
	jack@suse.cz, Christian Brauner <brauner@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>,
	"Serge E. Hallyn" <serge@hallyn.com>, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, linux-bcachefs@vger.kernel.org,
	linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
	Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH 1/2 v2] bcachefs: do not use PF_MEMALLOC_NORECLAIM
Message-ID: <ZtBzstXltxowPOhR@dread.disaster.area>
References: <20240826085347.1152675-2-mhocko@kernel.org>
 <20240827061543.1235703-1-mhocko@kernel.org>
 <Zs6jFb953AR2Raec@dread.disaster.area>
 <ylycajqc6yx633f4sh5g3mdbco7zrjdc5bg267sox2js6ok4qb@7j7zut5drbyy>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ylycajqc6yx633f4sh5g3mdbco7zrjdc5bg267sox2js6ok4qb@7j7zut5drbyy>

On Thu, Aug 29, 2024 at 06:02:32AM -0400, Kent Overstreet wrote:
> On Wed, Aug 28, 2024 at 02:09:57PM GMT, Dave Chinner wrote:
> > On Tue, Aug 27, 2024 at 08:15:43AM +0200, Michal Hocko wrote:
> > > From: Michal Hocko <mhocko@suse.com>
> > > 
> > > bch2_new_inode relies on PF_MEMALLOC_NORECLAIM to try to allocate a new
> > > inode to achieve GFP_NOWAIT semantic while holding locks. If this
> > > allocation fails it will drop locks and use GFP_NOFS allocation context.
> > > 
> > > We would like to drop PF_MEMALLOC_NORECLAIM because it is really
> > > dangerous to use if the caller doesn't control the full call chain with
> > > this flag set. E.g. if any of the function down the chain needed
> > > GFP_NOFAIL request the PF_MEMALLOC_NORECLAIM would override this and
> > > cause unexpected failure.
> > > 
> > > While this is not the case in this particular case using the scoped gfp
> > > semantic is not really needed bacause we can easily pus the allocation
> > > context down the chain without too much clutter.
> > > 
> > > Acked-by: Christoph Hellwig <hch@lst.de>
> > > Signed-off-by: Michal Hocko <mhocko@suse.com>
> > 
> > Looks good to me.
> > 
> > Reviewed-by: Dave Chinner <dchinner@redhat.com>
> 
> Reposting what I wrote in the other thread:

I've read the thread. I've heard what you have had to say. Like
several other people, I think your position is just not practical or
reasonable.

I don't care about the purity or the safety of the API - the
practical result of PF_MEMALLOC_NORECLAIM is that __GFP_NOFAIL
allocation can now fail and that will cause unexpected kernel
crashes.  Keeping existing code and API semantics working correctly
(i.e. regression free) takes precedence over new functionality or
API features that people want to introduce.

That's all there is to it. This is not a hill you need to die on.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
