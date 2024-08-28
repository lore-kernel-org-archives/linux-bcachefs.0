Received: from mail-oo1-f45.google.com (mail-oo1-f45.google.com [209.85.161.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F21641DA21
	for <linux-bcachefs@vger.kernel.org>; Wed, 28 Aug 2024 04:10:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724818204; cv=none; b=oV7a0YioAbrdYQM5/MasgDC4NPcKuys+ZyWtIasUh7sTu3XQpZ2O9uKH8OLAZ36VmDXUjLp3LPaYjINTZN0S4mEPKtA53Yz1QBVAuCSQor5Rnpa6OmBzTb8KNQxEWd9jKuuyM2n1Ruieyiv/jzkujJDto2u7l9i0jcxUN9XifSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724818204; c=relaxed/simple;
	bh=zNlNxjFW08JSSEcyMPvi4h5DZH3WzzFkawQQUbG3njo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AYN1Bt0rJQM5h1IykWaPV947KH96tV0H2diPSutI8YTqJsZM2KQhmaiJ4Y1HM+rY3envoiKKRkcTYiGQJdfuU1Vz2JPLwy3Hiit/CHKIjo/t/sqydA8pjMaywOhj3lQNscG4qWNM30F20eD6AxpVPVSNZuVGnpsf1JV+eETewiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=ogYpZJeJ; arc=none smtp.client-ip=209.85.161.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="ogYpZJeJ"
Received: by mail-oo1-f45.google.com with SMTP id 006d021491bc7-5d5e97b84fbso4810386eaf.1
        for <linux-bcachefs@vger.kernel.org>; Tue, 27 Aug 2024 21:10:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1724818201; x=1725423001; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=TbUlXEtla2rVUESWfqavCUSiACHVI6vmcJ0NsirDOl4=;
        b=ogYpZJeJCWC26f4eswjmffJffjMHzY7WOGWDv/8n3yhN5BLJuWqGRQvRrBKEX7NuEJ
         YkIZmgbgv0Xv9ICerTAjo0Nd5L03a47n+kZ6rYRhKx+x2YKSwY9ScjB+y/Ui8pWYzZt8
         vJBqoRpCB4lpK+luMv7d2kZ7uGzSLNglH1WB9yeQnnChIamUmjJ9D8eatMxnbqhpab3Y
         UnMtG3pZXam98GJBpdydDC7t8jkhbntMcc3KKthNzv+JpHakYz3Hlg5mKUZQnOGydQEK
         qzKtJnB3zAAP+kyRpzaw38L6jKcsXIZXFIVFTrMEVUISarq/4IzjG4pl+9jUOxkS8IZh
         WInA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724818201; x=1725423001;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TbUlXEtla2rVUESWfqavCUSiACHVI6vmcJ0NsirDOl4=;
        b=tyq1+OSo8/3jbt+gndhko6NgcxCXOJvOJSQtDV2URlVFPehbYMDpnVeUCcenXjgoGJ
         sCjB3xzwRKutiM0MjQYYhqbCWQ1OiJvtExkbpCNY47SjwFbJbnnXUPl6u5cve9YHEfCr
         5d7Oidl+lP+cJUXg2RdSCemYTVIMUwhiTOAhlu3osZCHeFuvfjlkuHlDkhl44rZEuOha
         PCEREWtzlBh1C07D6+pSJdK+I+f0TYZy11QTzEK2hdyYqBrWLlboAoCvqBH4rFNUZ921
         oXE/jd4BlVsg4wzfJKTjsFCl2O9bcpoF9jFyKJ5Jgd5hzaUnq32VAZvt4Oc1t0jX+UNB
         StLg==
X-Forwarded-Encrypted: i=1; AJvYcCVgg5l6v9RyYyjrdYTnzGxUOkRAPDSC1zHIg6d6K9hZ/Y//tuYJHmQmiRVkF+cawRSZGxtEQOOw1d4cl6me/g==@vger.kernel.org
X-Gm-Message-State: AOJu0Yz/s9FjPpgnvH+ZSLhpeSmpgpKgi9V2GUMGE7TvIX0/JEgkFyCx
	Dg+pVPDPjPJBAMtWeK/2h6tCbCg8a4YoazGZSuwFd1BVkblYKxqPq6q7JbvNQkM=
X-Google-Smtp-Source: AGHT+IFfFN76jaKMmeyJLYLrAmGyGf6VTmFCJDdjyeumUMkRB244pfXxTGN0Cua4OLIg1wtsh8Hazg==
X-Received: by 2002:a05:6358:9143:b0:1b1:a961:7977 with SMTP id e5c5f4694b2df-1b5fad71e17mr97610355d.29.1724818200852;
        Tue, 27 Aug 2024 21:10:00 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-0-65.pa.nsw.optusnet.com.au. [49.179.0.65])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7143432ee26sm9279075b3a.188.2024.08.27.21.10.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Aug 2024 21:10:00 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1sjA0L-00FJwC-3A;
	Wed, 28 Aug 2024 14:09:58 +1000
Date: Wed, 28 Aug 2024 14:09:57 +1000
From: Dave Chinner <david@fromorbit.com>
To: Michal Hocko <mhocko@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Christoph Hellwig <hch@lst.de>, Yafang Shao <laoar.shao@gmail.com>,
	Kent Overstreet <kent.overstreet@linux.dev>, jack@suse.cz,
	Christian Brauner <brauner@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>,
	"Serge E. Hallyn" <serge@hallyn.com>, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, linux-bcachefs@vger.kernel.org,
	linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
	Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH 1/2 v2] bcachefs: do not use PF_MEMALLOC_NORECLAIM
Message-ID: <Zs6jFb953AR2Raec@dread.disaster.area>
References: <20240826085347.1152675-2-mhocko@kernel.org>
 <20240827061543.1235703-1-mhocko@kernel.org>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240827061543.1235703-1-mhocko@kernel.org>

On Tue, Aug 27, 2024 at 08:15:43AM +0200, Michal Hocko wrote:
> From: Michal Hocko <mhocko@suse.com>
> 
> bch2_new_inode relies on PF_MEMALLOC_NORECLAIM to try to allocate a new
> inode to achieve GFP_NOWAIT semantic while holding locks. If this
> allocation fails it will drop locks and use GFP_NOFS allocation context.
> 
> We would like to drop PF_MEMALLOC_NORECLAIM because it is really
> dangerous to use if the caller doesn't control the full call chain with
> this flag set. E.g. if any of the function down the chain needed
> GFP_NOFAIL request the PF_MEMALLOC_NORECLAIM would override this and
> cause unexpected failure.
> 
> While this is not the case in this particular case using the scoped gfp
> semantic is not really needed bacause we can easily pus the allocation
> context down the chain without too much clutter.
> 
> Acked-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Michal Hocko <mhocko@suse.com>

Looks good to me.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
