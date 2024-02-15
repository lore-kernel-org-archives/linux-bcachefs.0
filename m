Received: from mail-108-mta97.mxroute.com (mail-108-mta97.mxroute.com [136.175.108.97])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 933ADDDD8
	for <linux-bcachefs@vger.kernel.org>; Thu, 15 Feb 2024 07:31:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=136.175.108.97
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707982272; cv=none; b=rhQTY6kHk8R5tmmMNNid5dLCqm+XFCxCPLKkG20YNheuQkF/me+8MmAomwL4lXWbp6yeTSblQMcwl63IT/CakRQElGk8oriUvnJySY2bypOa67StiXD+DYY94NoQu63LxrvRpWHSrfWaTFnx5QlblBuWiE8NB4WaES5w+D2n5GU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707982272; c=relaxed/simple;
	bh=/wdXp6oytFcvEkbai6GX7Bhz6BDeCKIz8r4l1B9ZRJ4=;
	h=References:From:To:Cc:Subject:Date:In-reply-to:Message-ID:
	 MIME-Version:Content-Type; b=jnz8IjD426Pi4wG1TWo9eNgOlUDeSsV6Xp+pbg3pikZtUXo7ZNXGpt5srn7aqPvbbOK/Q+zrAJj4v1GL2/WhDQXwdTL0HWvKBdZsTQf2yWujseWzzyFNLWkGTIBEKLUybqfsFjzta3Ms2+DA+cvlSKH1fU4UuBlD3rhX6XINACg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=damenly.org; spf=pass smtp.mailfrom=damenly.org; dkim=pass (2048-bit key) header.d=damenly.org header.i=@damenly.org header.b=nu34ylBa; arc=none smtp.client-ip=136.175.108.97
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=damenly.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=damenly.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=damenly.org header.i=@damenly.org header.b="nu34ylBa"
Received: from filter006.mxroute.com ([136.175.111.2] filter006.mxroute.com)
 (Authenticated sender: mN4UYu2MZsgR)
 by mail-108-mta97.mxroute.com (ZoneMTA) with ESMTPSA id 18daba867d60000466.003
 for <linux-bcachefs@vger.kernel.org>
 (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384);
 Thu, 15 Feb 2024 07:25:57 +0000
X-Zone-Loop: 2ee8342db6eb64dcc4d2523af2ae9e6dcf255868f1ed
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=damenly.org
	; s=x; h=Content-Type:MIME-Version:Message-ID:In-reply-to:Date:Subject:Cc:To:
	From:References:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=WfzvBn8CwEdgC0yyJQ8n4G14cJr/mkmQJSog6DPpdn4=; b=nu34ylBa9Z8QrJ3WydMcoUoUSM
	ZQhEbhPOW5GOVCQijcrwLKL+53mB9+ceG9Yo0U2vww/Yp9H5I2AxmcS4mEc2/Sj5+Sec/8L5md4zl
	GD3amyF0xTc8f2UN4NHCzWLrwVgGKAPN0RY2SxV9MhSV6DEIT8xXFaX3gdl6ToB1zAJ30k30wQV/z
	0GpF6KUrUtrB7L+8k47cEu7ZWTdw8q4pvSaS9ycRgjc/MKBq1Vzj8aiNF4f+mCqqyaDsdCgAeS4mz
	kRei/FL+mLlseiWGzdkK5RQ1R2S+9vtMPR4oRv2zHwv1TTD09XGek8fgY0q6nlHLQM/0scw+jdcob
	tfgzrG0w==;
References: <20240205154814.910664-1-bfoster@redhat.com>
 <4fdyk3to57izolmljjiehnn5kt5dxckhh2oodo7vk6gssgqbsb@6gsjfytnv2xy>
 <ZcE5JY279PGUrP9F@bfoster> <il2yfjaa.fsf@damenly.org>
 <Zc0C32sbI2zjSDgL@bfoster>
User-agent: mu4e 1.7.5; emacs 28.2
From: Su Yue <l@damenly.org>
To: Brian Foster <bfoster@redhat.com>
Cc: Su Yue <l@damenly.org>, Kent Overstreet <kent.overstreet@linux.dev>,
 linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH] bcachefs: fix iov_iter count underflow on sub-block dio
 read
Date: Thu, 15 Feb 2024 14:59:35 +0800
In-reply-to: <Zc0C32sbI2zjSDgL@bfoster>
Message-ID: <cysyb36w.fsf@damenly.org>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
X-Authenticated-Id: l@damenly.org


On Wed 14 Feb 2024 at 13:13, Brian Foster <bfoster@redhat.com> 
wrote:

> On Fri, Feb 09, 2024 at 10:39:43AM +0800, Su Yue wrote:
>>
>> On Mon 05 Feb 2024 at 14:38, Brian Foster <bfoster@redhat.com> 
>> wrote:
>>
>> > On Mon, Feb 05, 2024 at 02:15:36PM -0500, Kent Overstreet 
>> > wrote:
>> > > On Mon, Feb 05, 2024 at 10:48:14AM -0500, Brian Foster 
>> > > wrote:
>> > > > bch2_direct_IO_read() checks the request offset and size 
>> > > > for >
>> > > sector
>> > > > alignment and then falls through to a couple calculations 
>> > > > to >
>> > > shrink
>> > > > the size of the request based on the inode size. The 
>> > > > problem > is
>> > > that
>> > > > these checks round up to the fs block size, which runs 
>> > > > the > risk
>> > > of
>> > > > underflowing iter->count if the block size happens to be 
>> > > > > large
>> > > > enough. This is triggered by fstest generic/361 with a 4k 
>> > > > > block
>> > > > size, which subsequently leads to a crash.
>> > > >
>> > > > After some discussion, the original purpose of the 
>> > > > shorten > logic
>> > > in this
>> > > > path is not totally clear. It appears to be intended as 
>> > > > an >
>> > > optimization
>> > > > of limited value, so simplify things and avoid the 
>> > > > underflow >
>> > > problem by
>> > > > removing it.
>> > >
>> > > Thinking about this a bit more...
>> > >
>> > > All that we're avoiding with the shorten is zeroing out the 
>> > > rest of
>> > > the
>> > > read, which will happen in bch2_read_extent(); we won't be 
>> > > issuing
>> > > any
>> > > IO, since that would require real data extents above 
>> > > i_size, which
>> > > is of
>> > > course not allowed.
>> > >
>> > > But zeroing out the rest of the read is actual work that's 
>> > > being
>> > > avoided, since if we return a short read (which is what 
>> > > we're doing
>> > > here) it's undefined what happens to the rest of the 
>> > > buffer.
>> > >
>> > > So... maybe we should keep it, for the crazy but inevitable
>> > > application
>> > > that uses a 1MB read buffer for everything, including 
>> > > O_DIRECT reads
>> > > to
>> > > 4k files?
>> > >
>> >
>> > I had another change around that basically just protected 
>> > against the
>> > underflow. I.e., something along the lines of the following, 
>> > to also
>> > cover the additional use of shorten later in the function:
>> >
>> > 	if (shorten >= iter->count)
>> > 		shorten = 0;
>> >

Sorry for the misleading reply.
I mean the check of shorten is efficient and simpler which looks 
good to me.

>>
>> The change is a clean fix without breaking logic in 
>> bch2_direct_IO_read.
>> If without shroten, the next loop counting on iter->count must 
>> be altered.
>> I'd like the simpler way.
>>
>
> Hi Su,
>
> I'm not quite following your comment on the "next loop counting 
> on
> iter->count." Can you elaborate? Also, which option are you 
> calling more
> simple? :) Thanks.
>
I think I just explained Kent's opinion in another way. The loop 
is

fs/bcachefs/fs-io-direct.c:
static int bch2_direct_IO_read(struct kiocb *req, struct iov_iter 
*iter) {
91         iter->count -= shorten;
...
130         while (iter->count) {
                ...
                bch2_read()
            }

            iter->count += shorten;
}

bch2_direct_IO_read() does all boundary check for dio. If shorten 
is
removed and no other condition in the loop, it brings more bios,
more btree searches in bch2_read[_extent].

--
Su
> Brian
>
>> --
>> Su
>>
>> > ... and IIRC that seemed to work as well. But I'll probably 
>> > have to take
>> > a closer look at that large buffer case to grok what's 
>> > happening and the
>> > original purpose of this logic.
>> >
>> > Brian
>>
