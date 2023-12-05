Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Vo2zXoUD"
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2562C129
	for <linux-bcachefs@vger.kernel.org>; Tue,  5 Dec 2023 06:53:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701788024;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Sg5ZUx+fcDNL8/koH5e+xD4Rd0Z2ue5Z8G6f5hh22Xk=;
	b=Vo2zXoUDkOf5c4s6QJtbT5EANpRD94wUG5grpvGCLzHktiO8G6coyAEoRJkTkm5WKEe9HC
	LrhHqcLKO11hATbT+dZH3Ys6js8hG4XSHbYxFeT70AVAdRcVZ53IqOsRWAShkUU+L5m7BS
	MjU3HjZKa2AOKc9LWJAQi7y080ffe70=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-323-kLbUmprFNU2IzzY-5DEwaQ-1; Tue, 05 Dec 2023 09:53:41 -0500
X-MC-Unique: kLbUmprFNU2IzzY-5DEwaQ-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BFB1B8370F1;
	Tue,  5 Dec 2023 14:53:40 +0000 (UTC)
Received: from bfoster (unknown [10.22.32.38])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9B0B4492BE6;
	Tue,  5 Dec 2023 14:53:40 +0000 (UTC)
Date: Tue, 5 Dec 2023 09:54:36 -0500
From: Brian Foster <bfoster@redhat.com>
To: Steve Smith <tarkasteve@gmail.com>
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: [bug]: fiemap returns zero extents for all files
Message-ID: <ZW85rKUfEXeaWqsL@bfoster>
References: <CAHLWS5EiGVn_-BFm2X1PKZ2m0EJq6VjckLdOuVqL2zWibxYUqA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHLWS5EiGVn_-BFm2X1PKZ2m0EJq6VjckLdOuVqL2zWibxYUqA@mail.gmail.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.10

On Tue, Dec 05, 2023 at 04:26:40PM +1100, Steve Smith wrote:
> Hi,
> 
> I'm doing some testing of xcp[1] against bcachefs, and having issues
> with fiemap. Using fiemap on both sparse and non-sparse files always
> returns `mapped_extents` of 0. The same tests on other extent-based
> FSs return non-zero extents, with consistent values. This is against
> -rc4 and master.
> 
> I've broken the relevant tests (in Rust) out into a standalone crate
> if you want to reproduce:
> 
>     https://github.com/tarka/bcachefs-test
> 
> The FS in question was created with a simple `bcachefs -L xcp-test /dev/sdh1`.
> 

Hi Steve,

Well I'm not really familiar with xcp or your test harness here, but
have you checked the results you're seeing against known working tools?
For example, one of the subtests just seems to perform a simple write
followed by an fiemap check/assert for a single extent. That is roughly
equivalent to:

# xfs_io -fc "pwrite 0 128k" -c "fiemap -v" ./file
wrote 131072/131072 bytes at offset 0
128 KiB, 32 ops; 0.0011 sec (108.790 MiB/sec and 27850.3046 ops/sec)
./file:
 EXT: FILE-OFFSET      BLOCK-RANGE      TOTAL FLAGS
   0: [0..127]:        339968..340095     128   0x0
   1: [128..255]:      340096..340223     128   0x1

... which mostly seems to DTRT. I have noticed in the past that bcachefs
fiemap seems to break extents into bucket size or some such segments,
regardless of contiguity, but this doesn't seem to be the issue you are
reporting here. I.e. an strace of the above shows the following for the
fiemap ioctl():

ioctl(3, FS_IOC_FIEMAP, {fm_start=0, fm_length=18446744073709551615, fm_flags=FIEMAP_FLAG_SYNC, fm_extent_count=32} => {fm_flags=FIEMAP_FLAG_SYNC, fm_mapped_extents=2, ...}) = 0

... which shows fm_mapped_extents == 2. Hm?

Brian

> Cheers,
> Steve
> 
> [1]: https://github.com/tarka/xcp
> 

