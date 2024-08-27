Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F301E33999
	for <linux-bcachefs@vger.kernel.org>; Tue, 27 Aug 2024 06:58:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724741923; cv=none; b=ip3xPu3BpWdtp/w/+DeRxbHkdJfzDAG0sEpPmrXgQLS8f+u99v/bspZgt+fMKzjQb6oWYs6BEzt6JQsU/zdAJVAveQU5v3nZtqaNN5MJAp0MQY8vH/C15zbmcrTMrDNmNz3T/z25SKCJnjReGTjOf6bNiqTw0ZvCIpNwY/JQmsI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724741923; c=relaxed/simple;
	bh=8tSxgHbCYvYfA2twn1DWsR/FmG9GAaUjOojn+KhbU3s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VC+HGz2jbJmc8W8ZLVT6RZOzGHZqejrvM6ZllbTYrDE4H0UktJX5f3F8ikC53p2Faa+b7MMXf8G/7Kr918ONKCKDfIciuE/0uJ/y3uukWwGWYrF3QjXKfqULL2QrU8bDyb1mxGyjA8Tdjkg+cx9leac1hOvxIhZNSibadU71yLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=UJMQ3eoc; arc=none smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="UJMQ3eoc"
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-5bed68129a7so6745823a12.2
        for <linux-bcachefs@vger.kernel.org>; Mon, 26 Aug 2024 23:58:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1724741920; x=1725346720; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZY9iE015kjWusc18TRiosgvJ+Wsi74GjN7yQxl/1tqw=;
        b=UJMQ3eoc/HyHz1hxF0OvxtbhywSSZGZEefoRaLeIbv9dVsVkvsB1hmjhnUsRKtzZVd
         u1BF5SwPxCL56TtheMap3a+w4zmKr5EwvpdUQy7VVJfhXp6WmDfbistd/Htb0CXxYtvA
         HaisewGqKxD765YWqk4RdJmuXiK8sY+VljTgIfZzEPA5CtelfKZ56XZqnhszmpWmTB4j
         4hhnZbnaEev7rgIhZ3a3ThLKQpiJdYcb1hoRV3Bq/O38o3p2S8vLyYXuVOMTN9eTIAwU
         rd5dgD9KLCxbNJkrSglLz8tnH3hYf8ho1c0ow4Nye2myzSzUOof2dATjIp38U+l6sE+b
         AQ8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724741920; x=1725346720;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZY9iE015kjWusc18TRiosgvJ+Wsi74GjN7yQxl/1tqw=;
        b=UQd7oUvXRjazOgF1wgu+wV1QEsRKhyLuaBqeC9AqBPi6uYShifKxCrxDyEFby9BBzT
         FBA7ZZsU9hcxPvKlY89X6EVUtuCI8v1IMVwzUVjN9DYnHmHPyXyRE9Kreb1E1N8VmywJ
         qSgfFNODjwR1EiKwrbuFLaujYTwuWp6Y3fkURMA0yeUNiA6CYgBGC9mgVIvV5udkj4HI
         u64v47bsyS/8g+GuAxeJNFdcMVUwyxYeyN64wU9+gcCxNKy5YbRmSXTImMwH6gN+pPAh
         DjVxrLn3S/vNYQ3vmGY2q3NnDtk6aqA0DT+qWE7AA+zcHCTIYIl3VSSe0xfQV1nSH9gk
         L/4w==
X-Forwarded-Encrypted: i=1; AJvYcCUE5o+c4STJCZVc8CATDrKq1nNWMpGQmQm/6X7HsGVftXoGFIhFVQ64IH6wb6YisUP3p/9osrIHWyII5Ru1bw==@vger.kernel.org
X-Gm-Message-State: AOJu0YwwF1+sN6KTAx3JdOf9+yXzGozM7ANHigoLms7AmGTOrO+y6FJi
	azHIX9oWzzyUOhJK+Z1l/MatBoyILkQFy+2kirMCCuOd66NrqVxMAk72O2qBfg4=
X-Google-Smtp-Source: AGHT+IHGiyAa7bX/33A23l80oaz7c5FgGRiOJ9rxmhA/0tIr4irzNxptSfoweilUX1Ghv/r+StubWg==
X-Received: by 2002:a05:6402:90b:b0:5be:bcdf:4110 with SMTP id 4fb4d7f45d1cf-5c08910fb32mr8955148a12.0.1724741920178;
        Mon, 26 Aug 2024 23:58:40 -0700 (PDT)
Received: from localhost (109-81-92-122.rct.o2.cz. [109.81.92.122])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5c0bb471981sm640391a12.71.2024.08.26.23.58.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Aug 2024 23:58:39 -0700 (PDT)
Date: Tue, 27 Aug 2024 08:58:39 +0200
From: Michal Hocko <mhocko@suse.com>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Christoph Hellwig <hch@lst.de>, Yafang Shao <laoar.shao@gmail.com>,
	jack@suse.cz, Christian Brauner <brauner@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>,
	"Serge E. Hallyn" <serge@hallyn.com>, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, linux-bcachefs@vger.kernel.org,
	linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] bcachefs: do not use PF_MEMALLOC_NORECLAIM
Message-ID: <Zs15H6sT-QhvcZqa@tiehlicka>
References: <20240826085347.1152675-1-mhocko@kernel.org>
 <20240826085347.1152675-2-mhocko@kernel.org>
 <egma4j7om4jcrxwpks6odx6wu2jc5q3qdboncwsja32mo4oe7r@qmiviwad32lm>
 <ZszeUAMgGkGNz8H9@tiehlicka>
 <d5zorhk2dmgjjjta2zyqpyaly66ykzsnje4n4j4t5gjxzt57ty@km5j4jktn7fh>
 <ZszlQEqdDl4vt43M@tiehlicka>
 <ut5zfyvpkigjqev43kttxhxmpgnbkfs4vdqhe4dpxr6wnsx6ct@qmrazzu3fxyx>
 <Zs1rvLlk0mXklHyf@tiehlicka>
 <ru3d2bfrnyap7t3ya5kke3fqyrnj2hgbl4z2negbqkqj7z4mr2@gqrstl4lpl5h>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ru3d2bfrnyap7t3ya5kke3fqyrnj2hgbl4z2negbqkqj7z4mr2@gqrstl4lpl5h>

On Tue 27-08-24 02:40:16, Kent Overstreet wrote:
> On Tue, Aug 27, 2024 at 08:01:32AM GMT, Michal Hocko wrote:
> > You are not really answering the main concern I have brought up though.
> > I.e. GFP_NOFAIL being fundamentally incompatible with NORECLAIM semantic
> > because the page allocator doesn't and will not support this allocation
> > mode.  Scoped noreclaim semantic makes such a use much less visible
> > because it can be deep in the scoped context there more error prone to
> > introduce thus making the code harder to maintain. 
> 
> You're too attached to GFP_NOFAIL.

Unfortunatelly GFP_NOFAIL is there and we need to support it. We cannot
just close eyes and pretend it doesn't exist and hope for the best.

> GFP_NOFAIL is something we very rarely use, and it's not something we
> want to use. Furthermore, GFP_NOFAIL allocations can fail regardless of
> this patch - e.g. if it's more than 2 pages, it's not going to be
> GFP_NOFAIL.

We can reasonably assume we do not have any of those users in the tree
though. We know that because we have a warning to tell us about that.
We still have legit GFP_NOFAIL users and we can safely assume we will
have some in the future though. And they have no way to handle the
failure. If they did they wouldn't have used GFP_NOFAIL in the first
place. So they do not check for NULL and they would either blow up or
worse fail in subtle and harder to detect way.
 
-- 
Michal Hocko
SUSE Labs
