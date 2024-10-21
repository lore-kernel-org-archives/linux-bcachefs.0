Received: from mail-lj1-f176.google.com (mail-lj1-f176.google.com [209.85.208.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8224C14A90
	for <linux-bcachefs@vger.kernel.org>; Mon, 21 Oct 2024 16:15:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729527358; cv=none; b=B0nx3egUxp8y3I/pXghNx9VvAWlpzlhxdKsl9W5iaKzJZGemZxT5wIvWqpP/nO+Vb3j8ZNX34MflP7lCDGpaZVzABMWtXs+vKVklkBYG+GA2X7R4INxc6VLwpOYAo0yj9Tb6mq6e55NwvJ6hlIaK0LJl7RGGWme2hTeeauO/sas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729527358; c=relaxed/simple;
	bh=6adyUM6nfaN8g8a4EEfc51Tkd7RRLjvEbzfepYxcQlI=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oKP/+ZjQ9aquOeY7VYhJevLiWhTJrJs2/jtr9sF7y95JZkUaGssrDeopoPaTn50bqHLmqZ0mjtitLMGCgS8Z/QS6HI4UyB2DjFx9edV0QaxdMu03JB0bBfXE3yHaC5dr+qeeERHxkuciuwAzaP0o/TR+BUy3+6AfypWXnQCojEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ipf4uboe; arc=none smtp.client-ip=209.85.208.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ipf4uboe"
Received: by mail-lj1-f176.google.com with SMTP id 38308e7fff4ca-2f75c56f16aso45055881fa.0
        for <linux-bcachefs@vger.kernel.org>; Mon, 21 Oct 2024 09:15:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729527354; x=1730132154; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=hDCkRXzZMsmC9OcdH/PJ2FucYewOH9vBwnV76xL3TNM=;
        b=Ipf4uboeYNBYATD7htyFKQ+XAD3w1+3W060i9FczmbOe2u6PbW9bVEy+d1GsBhzMcv
         hQz31KHRdwwrRpPQKtwo/mgt/RDJcP5HwJEvQDw4hlCg1UawIxhjMpIyoMZ7EhmF9Cr5
         9reGHNO4gkkuBmJo+Oaqjj6TKTUETe7+CIkOE27TvIRJWJqmVUrII3dzpjknMQaTPFf9
         k8Du4YpDywE4dMPzO/zMuQwiIxX+Eoo6mL9kl0ZIiCDxoSsx7x/VJXCK/heDEX+UbDN5
         b7ZwJQpRBQMR2KH6Rdshv33mFlYWLURDtQIq8gE3sCvRUq1qjqmM5j9eORZ0JkC04hvl
         hnaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729527354; x=1730132154;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hDCkRXzZMsmC9OcdH/PJ2FucYewOH9vBwnV76xL3TNM=;
        b=KhKGkXd7oNSL86RAajKgjRphTy11/glZV5rRcSCIPgmL7V3d8wUBMW2gPBkv045fGg
         h9eRv0gpVHpa1TDIPd9Bj6yeonJCvN5C3uc+MfQZ9ot+LgxxjfMBA54naFhFjmzAYwvP
         xIBoZFugvdQGzX4upt2kM6m8owe23GCvEG0CFFDr+wdZRZGfQ907Rvn36897Kaim9vK4
         eWWwl625CTxFuZHnqFci6If010+709rJeCZZi56SCf0E8TPX5bMhtGYFY4yXRT1n3+49
         fYOiejqo3bwk1QhQfq08NyagR76pRIBMgvjt8Qx0KMCQcnV4a6R7/XbH2xccjjHf5Lyg
         C34A==
X-Forwarded-Encrypted: i=1; AJvYcCV7fPzpiJKCLFwFeGZqYT/VvZgcu/3Exxxl5bFlbFdTPQnGL/4rAIhZgXAZSdrf+CbFnh1q9xLxnQu9qmcGeg==@vger.kernel.org
X-Gm-Message-State: AOJu0YxG7vBDFsvDzmE/hYZ7wMBXdXxMN5iO8gwYD7Hv+E2qjK2egzQx
	OLxEKUwViSC2TUGeJ0zCkx1jnTYxzXxJydz4c3g7G6mK0l9x3jpo
X-Google-Smtp-Source: AGHT+IG2h1dAnakaDzA9jqhK0kzf0ExHRZDYTYVZSzXXU1tOMfyuMkFIlh/zpiO3wAsQhBR/2UjqXw==
X-Received: by 2002:a2e:d01:0:b0:2fb:b59:8167 with SMTP id 38308e7fff4ca-2fb8320ba5emr44846581fa.39.1729527354158;
        Mon, 21 Oct 2024 09:15:54 -0700 (PDT)
Received: from pc636 (host-90-233-222-236.mobileonline.telia.com. [90.233.222.236])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-2fb9ad4b843sm5296961fa.4.2024.10.21.09.15.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Oct 2024 09:15:53 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@pc636>
Date: Mon, 21 Oct 2024 18:15:50 +0200
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	linux-bcachefs@vger.kernel.org, linux-mm@kvack.org,
	Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Uladzislau Rezki <urezki@gmail.com>,
	Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] mm: Drop INT_MAX limit from kvmalloc()
Message-ID: <ZxZ-NmNAft1Xk0Cy@pc636>
References: <20241019210037.146825-1-kent.overstreet@linux.dev>
 <90bc0794-4cab-415f-a442-4af85a32eed8@lucifer.local>
 <ucbcmk4kr7tbvj6uqnjke5662kerawbr4ghtlbw4zim7mdm3fg@vjawfne5rdkp>
 <ebe58a08-2371-403c-a0d7-6280160b6848@lucifer.local>
 <zfr4sh3wtzi4viladlgwyon6voqhcj5fe3fv2nc3hqyyxdw5wd@onyj3r2m3usz>
 <CAHk-=wi=PrbZnwnvhKEF6UUQNCZdNsUbr+hk-jOWGr-q4Mmz=Q@mail.gmail.com>
 <m46mlvv57oypstekojhkdwpts6mi4r63l4kugs4lpry3d2r7dq@kbmied6nzsc3>
 <CAHk-=wg8iZWDbX_MAujGtqHJYQneKBwDJnVAY94siNr1gLmtaA@mail.gmail.com>
 <CAHk-=wiW_QZ9VS3Ho2Ff8ZDp-T6SomDFrVPWG3abs45LMZpxZQ@mail.gmail.com>
 <axcfs66ldwl4okyhndkcz2vkfmshuoady5cxe76h6qvcfqt326@wvlkewrvbrxm>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <axcfs66ldwl4okyhndkcz2vkfmshuoady5cxe76h6qvcfqt326@wvlkewrvbrxm>

On Sun, Oct 20, 2024 at 03:16:11PM -0400, Kent Overstreet wrote:
> On Sun, Oct 20, 2024 at 12:09:58PM -0700, Linus Torvalds wrote:
> > On Sun, 20 Oct 2024 at 12:09, Linus Torvalds
> > <torvalds@linux-foundation.org> wrote:
> > >
> > > How about you limit the amount of memory you use in the first place instead?
> > 
> > .. and to clarify: we're not making other parts of the kernel less
> > robust because *you* are doing something stupid and odd.
> 
> Except, vmalloc() already behaves this way - so it seems to me you
> already have.
> 
> I've already added a stupid workaround to the darray code to switch to
> calling vmalloc() directly, when necessary; this patch was a courtesy
> because if bcachefs is hitting this limit no doubt other things will be
> soon as well.
>
I was thinking to prevent "big" allocations to limit the vmalloc() by
the INT_MAX sizes, i.e. to apply same limitation as kvmalloc() has.
vmalloc() is stick to totalram_pages() which is way a lot.

But it would break bcachefs, as i see it.

--
Uladzislau Rezki
