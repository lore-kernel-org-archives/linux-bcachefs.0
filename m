Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97FD9C2C6
	for <linux-bcachefs@vger.kernel.org>; Sun, 20 Oct 2024 19:16:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729451778; cv=none; b=QvRxWwzSFZqQmQb7PNMwJIG6SKc+oZMEFKp1ue9HGUAaNocKXUeyE9YuLV97XD4FgN8rB42LlJkuUHx2EasQY8PRF4OkDJuOP7CNsueZ+8qhCN/NvyrdpITU9KGcPqdzDwe8TYVqiVOgW4RCPnyN9xXts5W7rB45oQK1NmgWgw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729451778; c=relaxed/simple;
	bh=uWvelbJUoGVIURerxJrleltdsLEXNHHcbo1II548Hi0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=frwlNdI0AI5+04ln5m6gQS5lE9u59oqI9lILETR5pd7uvUW1gT+fVoqa4A7MF16F2qCtwZYpdHJqcqw+wsjD3ogNH55kXJSPDXAyLLzyAi3i+mlFB64iQj7gDf9DWdNTcAXI36jvBQKREwAigCQuVOUdiqWlVTub4Api66RBIXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=s0y8yF6A; arc=none smtp.client-ip=91.218.175.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="s0y8yF6A"
Date: Sun, 20 Oct 2024 15:16:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1729451774;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=QsqXAYXQDUiVX9tYvJluW0Iklg/6NIBwGb+7FHIrNzg=;
	b=s0y8yF6AgV6/HIHieLpA7WU+r5SpcjI8tHmg04ycg6b2hsp7R0njH5muHd9Wy7ray8mRa3
	Efwilt9QovtEVbd0Zy31MJRiLA78lp0SHxNzBxmdBGTcKAZfBbVyq1YWQ47ZC33HWcl1ux
	8I8u0C4Tg2phQruMQKiojkSG6NYwggg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	linux-bcachefs@vger.kernel.org, linux-mm@kvack.org, Vlastimil Babka <vbabka@suse.cz>, 
	Andrew Morton <akpm@linux-foundation.org>, Uladzislau Rezki <urezki@gmail.com>, 
	Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] mm: Drop INT_MAX limit from kvmalloc()
Message-ID: <axcfs66ldwl4okyhndkcz2vkfmshuoady5cxe76h6qvcfqt326@wvlkewrvbrxm>
References: <20241019210037.146825-1-kent.overstreet@linux.dev>
 <90bc0794-4cab-415f-a442-4af85a32eed8@lucifer.local>
 <ucbcmk4kr7tbvj6uqnjke5662kerawbr4ghtlbw4zim7mdm3fg@vjawfne5rdkp>
 <ebe58a08-2371-403c-a0d7-6280160b6848@lucifer.local>
 <zfr4sh3wtzi4viladlgwyon6voqhcj5fe3fv2nc3hqyyxdw5wd@onyj3r2m3usz>
 <CAHk-=wi=PrbZnwnvhKEF6UUQNCZdNsUbr+hk-jOWGr-q4Mmz=Q@mail.gmail.com>
 <m46mlvv57oypstekojhkdwpts6mi4r63l4kugs4lpry3d2r7dq@kbmied6nzsc3>
 <CAHk-=wg8iZWDbX_MAujGtqHJYQneKBwDJnVAY94siNr1gLmtaA@mail.gmail.com>
 <CAHk-=wiW_QZ9VS3Ho2Ff8ZDp-T6SomDFrVPWG3abs45LMZpxZQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wiW_QZ9VS3Ho2Ff8ZDp-T6SomDFrVPWG3abs45LMZpxZQ@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT

On Sun, Oct 20, 2024 at 12:09:58PM -0700, Linus Torvalds wrote:
> On Sun, 20 Oct 2024 at 12:09, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > How about you limit the amount of memory you use in the first place instead?
> 
> .. and to clarify: we're not making other parts of the kernel less
> robust because *you* are doing something stupid and odd.

Except, vmalloc() already behaves this way - so it seems to me you
already have.

I've already added a stupid workaround to the darray code to switch to
calling vmalloc() directly, when necessary; this patch was a courtesy
because if bcachefs is hitting this limit no doubt other things will be
soon as well.
