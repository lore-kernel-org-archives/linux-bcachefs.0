Received: from mail-oa1-f45.google.com (mail-oa1-f45.google.com [209.85.160.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 419BF1AED31
	for <linux-bcachefs@vger.kernel.org>; Thu, 20 Jun 2024 14:56:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718895404; cv=none; b=XzNXHbGfa0gTWeLnEuFkUasQbAqoKINq2eZmA7nZGEuSY6ZvQqltu7/Scfug8sMCWlqelRL6tSvkvHHnTsvOJWO396BWqvuscxaMhlY1IvyvaUdPtbYHZNSTvPmFP63ddQ/U6vo5Gcj5VGVrF06XK2KpPGIbNCtICik6rhOYdi0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718895404; c=relaxed/simple;
	bh=dSD2fraarMvuCS5kF2lqW1MEvcZzsdHKJj+G90Wup8U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LuhRc1vpcDy3lvTKkanSwjqVNaS+2ldUI3/Udo4OzOPGx1oZbYcrbex9M7cq+sIKwaDnSyyhY3xXgSidveXUuOjJgfP4lBO8FaZdMxdC630x6TwHwz3OI4bY6JNDCqUlSd5gGeQIUBvy8R5KLdGZDE44Y5rNWW9W/CrrPxePpNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=rXAp9YhY; arc=none smtp.client-ip=209.85.160.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="rXAp9YhY"
Received: by mail-oa1-f45.google.com with SMTP id 586e51a60fabf-25cb022c0e6so84190fac.0
        for <linux-bcachefs@vger.kernel.org>; Thu, 20 Jun 2024 07:56:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1718895401; x=1719500201; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=27XNFtN27bIRXgBJLSD4u5NBdWTnMdT2PxNTypSG2y8=;
        b=rXAp9YhYr+fcHD8oVPwgjAa4dC0uHFHgZyuld2ig1wIxunT3a3Xsd46bywkL05vspQ
         bAt4TVP5thp6JSEwPqqdAbfSTUjwoEdgYSIr9MPiUL6YlgsTbvjEiyiZXvX54SJZtH8r
         WKIVXIke+4e/Y2xBhhQTO4FiFEifbmZdKHxd8hwxbNJw0/Q4ZUjj2A0xiReQM764zRyn
         /SvkfPCtDQbg5hRAVIz6SrxueYXSvhjU/Mx8raBTaeDBakd/3iRnzXGcV7D8DrFyf3Fr
         22x/YJlxdOpUXnQ3vHRb2w62gq95eZ6KkEyO59owHfqJZvbOE8Ud0MA4fUfrsYSkaDTZ
         s5SQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718895401; x=1719500201;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=27XNFtN27bIRXgBJLSD4u5NBdWTnMdT2PxNTypSG2y8=;
        b=OSZN18lYkWHyst+UJqn63QyT4lD2V4LAH/lqR7X4GPyBHuIc32B36c8bRX6t4N5F2W
         lNeOu/lrxkTUoUPfbD07kKS186Pa3/zLj94UqEZVihOo6fv46hRJezgrH4HQD3M2ah81
         VOi+D3jjkJh40TE9TLX5ubsnwwbSpPP2roXwh19J64AIlPcCCvefoBFLLYgza+lUyJCK
         5bGHUJ1xR2x37vnoYP8IzEKR+Mij9r5oQvsW2NB/RdNh0TO4/vEpiiCdEeTxXMZ1448z
         tnq2SdJFSGx5qhS04jUiO6LrjuDx3XHEQJWLp8B3Se0rix3CGebJ4W7agrwL3Hdnij2m
         5SnQ==
X-Forwarded-Encrypted: i=1; AJvYcCVeAGGOfqhTsISW6H+B5CNDDpP2sj/2pgvrvDW1YOvAG6ihSsneKqP6n044lcEDW+Ap2jrOceOTu3d4eXaVP7SGvpKaQIoymJqT355QaH8=
X-Gm-Message-State: AOJu0YyR9xL8i8TRHg45DGwcXT8w4FdKdE5n5RSqhQ+TL4A2OXAmSpcL
	dj1pMvBECdjOn856pepZy7J+j10hHy/8KI4mpl5kwROHXAL0Zfw4p8WbttK6OU0=
X-Google-Smtp-Source: AGHT+IGL2J1dIu5o4y1KRcELhXd+WtYbLw0M0Nl9QtzIiz5Wwd6DqkKRFUNt+RVjDQpLEpdyxc2zLw==
X-Received: by 2002:a05:6808:189e:b0:3d2:3bc2:71b2 with SMTP id 5614622812f47-3d51b7c6ee6mr6040506b6e.0.1718895401215;
        Thu, 20 Jun 2024 07:56:41 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-3d52529f459sm421231b6e.47.2024.06.20.07.56.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Jun 2024 07:56:40 -0700 (PDT)
Message-ID: <0f74318e-2442-4d7d-b839-2277a40ca196@kernel.dk>
Date: Thu, 20 Jun 2024 08:56:39 -0600
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: bvec_iter.bi_sector -> loff_t?
To: Matthew Wilcox <willy@infradead.org>,
 Kent Overstreet <kent.overstreet@linux.dev>
Cc: Hongbo Li <lihongbo22@huawei.com>, linux-bcachefs@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org, hch@lst.de
References: <20240620132157.888559-1-lihongbo22@huawei.com>
 <bbf7lnl2d5sxdzqbv3jcn6gxmtnsnscakqmfdf6vj4fcs3nasx@zvjsxfwkavgm>
 <ZnQ0gdpcplp_-aw7@casper.infradead.org>
 <pfxno4kzdgk6imw7vt2wvpluybohbf6brka6tlx34lu2zbbuaz@khifgy2v2z5n>
 <ZnRBkr_7Ah8Hj-i-@casper.infradead.org>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <ZnRBkr_7Ah8Hj-i-@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/20/24 8:49 AM, Matthew Wilcox wrote:
> On Thu, Jun 20, 2024 at 10:16:02AM -0400, Kent Overstreet wrote:
> I'm more sympathetic to "lets relax the alignment requirements", since
> most IO devices actually can do IO to arbitrary boundaries (or at least
> reasonable boundaries, eg cacheline alignment or 4-byte alignment).
> The 512 byte alignment doesn't seem particularly rooted in any hardware
> restrictions.

We already did, based on real world use cases to avoid copies just
because the memory wasn't aligned on a sector size boundary. It's
perfectly valid now to do:

struct queue_limits lim {
	.dma_alignment = 3,
};

disk = blk_mq_alloc_disk(&tag_set, &lim, NULL);

and have O_DIRECT with a 32-bit memory alignment work just fine, where
before it would EINVAL. The sector size memory alignment thing has
always been odd and never rooted in anything other than "oh let's just
require the whole combination of size/disk offset/alignment to be sector
based".

> But size?  Fundamentally, we're asking the device to do IO directly to
> this userspace address.  That means you get to do the entire IO, not
> just the part of it that you want.  I know some devices have bitbucket
> descriptors, but many don't.

We did poke at that a bit for nvme with bitbuckets, but I don't even
know how prevalent that support is in hardware. Definitely way iffier
and spotty than the alignment, where that limit was never based on
anything remotely resembling a hardware restraint.

>>> I'm against it.  Block devices only do sector-aligned IO and we should
>>> not pretend otherwise.
>>
>> Eh?
>>
>> bio isn't really specific to the block layer anyways, given that an
>> iov_iter can be a bio underneath. We _really_ should be trying for
>> better commonality of data structures.
> 
> bio is absolutely specific to the block layer.  Look at it:

It's literally "block IO", so would have to concur with that.

-- 
Jens Axboe

