Received: from mail-108-mta226.mxroute.com (mail-108-mta226.mxroute.com [136.175.108.226])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 588FB5223
	for <linux-bcachefs@vger.kernel.org>; Fri,  9 Feb 2024 02:51:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=136.175.108.226
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707447103; cv=none; b=vElOnpVfnQXeL9j2SMrgyOOES0wp1jGpgec5tRXL79Kk0ec9QhwxqlYTS5usJYFuOmePFBu+ROlxYZM3AY32IhrwBoG8OlWv+6Bnz88/xD8AppH4hT4g1+ye6JIFnvmIik68ZxWlxZr/Z+kZF0OatF4vlpcKdX+ktz7RugNS6mo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707447103; c=relaxed/simple;
	bh=Dc+6TGhY+jD0GXKBY5yF1WNLiW7EY4HYVPIjkarAhfc=;
	h=References:From:To:Cc:Subject:Date:In-reply-to:Message-ID:
	 MIME-Version:Content-Type; b=NRVM3yc1iJC98dzau7E25lE3dZLCnV1H9tsX2mUAUuP/gXJr9MYJCDgB2oIn3Mjn/pJXu3YUunFNUJgkTL6omMjaldFuu6I4OFS3igdaE65lhsc0Oz8GKUa74THzvdKylqbFfgSEerCm8v3551J9rdxYopbhbL8/POIDxDu1TbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=damenly.org; spf=pass smtp.mailfrom=damenly.org; dkim=pass (2048-bit key) header.d=damenly.org header.i=@damenly.org header.b=VU6yKW2R; arc=none smtp.client-ip=136.175.108.226
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=damenly.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=damenly.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=damenly.org header.i=@damenly.org header.b="VU6yKW2R"
Received: from filter006.mxroute.com ([136.175.111.2] filter006.mxroute.com)
 (Authenticated sender: mN4UYu2MZsgR)
 by mail-108-mta226.mxroute.com (ZoneMTA) with ESMTPSA id 18d8bc26a1b0000466.003
 for <linux-bcachefs@vger.kernel.org>
 (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384);
 Fri, 09 Feb 2024 02:46:30 +0000
X-Zone-Loop: 1fa22a1d18249f90db23db4581bcb8fb517be3cb87d8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=damenly.org
	; s=x; h=Content-Type:MIME-Version:Message-ID:In-reply-to:Date:Subject:Cc:To:
	From:References:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=qSZuHPEdnjxzu1DOok7l+PZrSMNUQroY8ZzwE0z8QWQ=; b=VU6yKW2RNf4FzPCC2FiRDVDH5B
	XpOpv66IfBT9eT9RGDu6v8JJuUcV42zNYrAICp4gSQZfkoY+Er0P0k/5Zdi91i0Kuz+J/Zvk3NO5K
	hryRbrSbjybJZ2hCyJxFm689HV97alFBuGZVjyVQZ3p0HmuBBz/AYd+a9kvb2T82aTFE7oiaIHEV2
	Q8RoBTzD2WvcTk4v8IFL/xYs5rQJM31MTlnxA0PXfQaLj0EX+AxiDW6LbyQj/fM4gOCqsjQCVosSe
	6IUOeAo+cdhFJCrAcxsE7N7D8UohW4BuBWIkF11OfvNgMTFXY0l0ShIPbzK98eZzd1uCKfUXKGHHi
	vFcd+1RA==;
References: <20240205154814.910664-1-bfoster@redhat.com>
 <4fdyk3to57izolmljjiehnn5kt5dxckhh2oodo7vk6gssgqbsb@6gsjfytnv2xy>
 <ZcE5JY279PGUrP9F@bfoster>
User-agent: mu4e 1.7.5; emacs 28.2
From: Su Yue <l@damenly.org>
To: Brian Foster <bfoster@redhat.com>
Cc: Kent Overstreet <kent.overstreet@linux.dev>, linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH] bcachefs: fix iov_iter count underflow on sub-block dio
 read
Date: Fri, 09 Feb 2024 10:39:43 +0800
In-reply-to: <ZcE5JY279PGUrP9F@bfoster>
Message-ID: <il2yfjaa.fsf@damenly.org>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
X-Authenticated-Id: l@damenly.org


On Mon 05 Feb 2024 at 14:38, Brian Foster <bfoster@redhat.com> 
wrote:

> On Mon, Feb 05, 2024 at 02:15:36PM -0500, Kent Overstreet wrote:
>> On Mon, Feb 05, 2024 at 10:48:14AM -0500, Brian Foster wrote:
>> > bch2_direct_IO_read() checks the request offset and size for 
>> > sector
>> > alignment and then falls through to a couple calculations to 
>> > shrink
>> > the size of the request based on the inode size. The problem 
>> > is that
>> > these checks round up to the fs block size, which runs the 
>> > risk of
>> > underflowing iter->count if the block size happens to be 
>> > large
>> > enough. This is triggered by fstest generic/361 with a 4k 
>> > block
>> > size, which subsequently leads to a crash.
>> >
>> > After some discussion, the original purpose of the shorten 
>> > logic in this
>> > path is not totally clear. It appears to be intended as an 
>> > optimization
>> > of limited value, so simplify things and avoid the underflow 
>> > problem by
>> > removing it.
>>
>> Thinking about this a bit more...
>>
>> All that we're avoiding with the shorten is zeroing out the 
>> rest of the
>> read, which will happen in bch2_read_extent(); we won't be 
>> issuing any
>> IO, since that would require real data extents above i_size, 
>> which is of
>> course not allowed.
>>
>> But zeroing out the rest of the read is actual work that's 
>> being
>> avoided, since if we return a short read (which is what we're 
>> doing
>> here) it's undefined what happens to the rest of the buffer.
>>
>> So... maybe we should keep it, for the crazy but inevitable 
>> application
>> that uses a 1MB read buffer for everything, including O_DIRECT 
>> reads to
>> 4k files?
>>
>
> I had another change around that basically just protected 
> against the
> underflow. I.e., something along the lines of the following, to 
> also
> cover the additional use of shorten later in the function:
>
> 	if (shorten >= iter->count)
> 		shorten = 0;
>

The change is a clean fix without breaking logic in 
bch2_direct_IO_read.
If without shroten, the next loop counting on iter->count must be 
altered.
I'd like the simpler way.

--
Su

> ... and IIRC that seemed to work as well. But I'll probably have 
> to take
> a closer look at that large buffer case to grok what's happening 
> and the
> original purpose of this logic.
>
> Brian
