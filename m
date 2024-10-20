Received: from sender4-op-o12.zoho.com (sender4-op-o12.zoho.com [136.143.188.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FA8B1DFD1
	for <linux-bcachefs@vger.kernel.org>; Sun, 20 Oct 2024 21:51:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729461101; cv=pass; b=TkvzYuLi5DaciZVZobxLpkfK8quqmz0ZG3bTfVVkjNk9a6FXbSBZge4QKyaLQKJ6QefZsy5J0YXGBkv1RzZTZMWab1IkxDQUBD/ZWg8MThua+EJ9es7Uk/gHupYCATgd3Eg7aUngMPczwg5+d0h98xj9mt1YMRKYUTpA1XrSvE4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729461101; c=relaxed/simple;
	bh=CwBXO14AhYKO2/tllQErZmp47ZpCBIY9mTz8m8S3fB8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dkFNd+8GrzK9h19w8fa3RNlgpN34ahE55lVAfcG3y3qyIdU4QVMH2WxgEgSZzB4HtLeja1hGdZSKO4RCQH5CuRspg2o3zfDCrgk/jeQmiUYeTawRkpKt2qs6kArIj1awHe0rJUYdCKxjzhIGORlGywJinpDIw/uQEauqqIxbjMg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=froggi.es; spf=pass smtp.mailfrom=froggi.es; dkim=pass (1024-bit key) header.d=froggi.es header.i=joshua@froggi.es header.b=HmXpAJmi; arc=pass smtp.client-ip=136.143.188.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=froggi.es
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=froggi.es
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=froggi.es header.i=joshua@froggi.es header.b="HmXpAJmi"
ARC-Seal: i=1; a=rsa-sha256; t=1729461074; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=KXwUdGO2sIsnWAIvIuWOcof4lYw3rF7qFO1lFV3eHFeQsRc3680tzNwUn1GNMCdsZyb3tyQtf5uhqPwHA+MD67yJVX5hUGoe0UI4PFmzLTI3pvvHKd3CK3DLKCfZFT+Z+59efw0AGS9FFgalk4nkPs/8Hyfk4vbBwg8vtk9VDpc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1729461074; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=+8w83Jkn9ES5BzP6kNp7Mqf1NH0mNG2o6IfBlRYom7Q=; 
	b=aAExMeujMGSPfT4fE6iojrSQlHrh9dczfyP3PjQqijKvyZiet5MCjfjNfOR2HyFW63EWy6E+0MebulVgKXllA8qnMMvJEx4ZvI3+9n3RSDAk2Xe2XX6Ate3APggC3Y6E7SpFJE1BvVXpP99sRUdBuYnd03FF8OK/nBiQ6eZpYgs=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=froggi.es;
	spf=pass  smtp.mailfrom=joshua@froggi.es;
	dmarc=pass header.from=<joshua@froggi.es>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1729461074;
	s=mail; d=froggi.es; i=joshua@froggi.es;
	h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=+8w83Jkn9ES5BzP6kNp7Mqf1NH0mNG2o6IfBlRYom7Q=;
	b=HmXpAJmi1oxJkxvo0BfBdfIbY1oVBlFIfhnq7AKrOpFYq/6dCY1fxzQbZr6EflMf
	Eej3mLkauSV+h6cXA7gc66Egfx6o5gdoedk9KgkD8WVB7/EPLD1i0LnKEchTJ8Tb3h8
	LY3kwt8ymYCGN2wmQi23Ft8k+GGkJ2ZgWA8LwLzg=
Received: by mx.zohomail.com with SMTPS id 1729461072846891.8886711215888;
	Sun, 20 Oct 2024 14:51:12 -0700 (PDT)
Message-ID: <690cd8b8-5095-4560-a555-773a2068305e@froggi.es>
Date: Sun, 20 Oct 2024 22:51:10 +0100
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: Drop INT_MAX limit from kvmalloc()
To: Kent Overstreet <kent.overstreet@linux.dev>,
 Linus Torvalds <torvalds@linux-foundation.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 linux-bcachefs@vger.kernel.org, linux-mm@kvack.org,
 Vlastimil Babka <vbabka@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
 Uladzislau Rezki <urezki@gmail.com>, Christoph Hellwig <hch@infradead.org>
References: <90bc0794-4cab-415f-a442-4af85a32eed8@lucifer.local>
 <ucbcmk4kr7tbvj6uqnjke5662kerawbr4ghtlbw4zim7mdm3fg@vjawfne5rdkp>
 <ebe58a08-2371-403c-a0d7-6280160b6848@lucifer.local>
 <zfr4sh3wtzi4viladlgwyon6voqhcj5fe3fv2nc3hqyyxdw5wd@onyj3r2m3usz>
 <CAHk-=wi=PrbZnwnvhKEF6UUQNCZdNsUbr+hk-jOWGr-q4Mmz=Q@mail.gmail.com>
 <m46mlvv57oypstekojhkdwpts6mi4r63l4kugs4lpry3d2r7dq@kbmied6nzsc3>
 <CAHk-=wg8iZWDbX_MAujGtqHJYQneKBwDJnVAY94siNr1gLmtaA@mail.gmail.com>
 <CAHk-=wiW_QZ9VS3Ho2Ff8ZDp-T6SomDFrVPWG3abs45LMZpxZQ@mail.gmail.com>
 <6eo3gekf6twbnzhpsi2emz2s6sgtof6iba2rvbor7himmejoq5@qbfwtpbpvqoe>
 <CAHk-=wga3FXReWVhU2eid8+sXhBF1QgP1iMJu1jnSX6fapoyXQ@mail.gmail.com>
 <ikaf72w2oap3crjrybbd5jp267slnb7dygz4m62dfw3edu2ppj@f7dv2qdx3yga>
Content-Language: en-US
From: Joshua Ashton <joshua@froggi.es>
In-Reply-To: <ikaf72w2oap3crjrybbd5jp267slnb7dygz4m62dfw3edu2ppj@f7dv2qdx3yga>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External



On 10/20/24 9:29 PM, Kent Overstreet wrote:
> On Sun, Oct 20, 2024 at 01:19:42PM -0700, Linus Torvalds wrote:
>> On Sun, 20 Oct 2024 at 13:10, Kent Overstreet <kent.overstreet@linux.dev> wrote:
>>>
>>> And the INT_MAX check wouldn't catch truncation anyways - it'd only
>>> catch integer _underflow_, but allocation size calculations pretty much
>>> as a rule never use subtractions, so I don't think this check was ever
>>> worth much to begin with.
>>
>> It fixed a real security issue.
> 
> Which you quite conveniently aren't naming.
> 
>> Enough said, and you're just making shit up to make excuses.
>>
>> Also, you might want to start look at latency numbers in addition to
>> throughput. If your journal replay needs an *index* that is 2G in
>> size, you may have other issues.
> 
> Latency for journal replay?
> 
> No, journal replay is only something happens at mount after an unclean
> shutdown. We can afford to take some time there, and journal replay
> performance hasn't been a concern.

Then why are you arguing about there being an "artificial cap on 
performance", if you can "afford to take some time there"?

Am I missing something?

- Joshie 🐸✨

> 
>> Your journal size is insane, and your "artificial cap on performance"
>> had better come with numbers.
> 
> I'm not going to run custom benchmarks just for a silly argument, sorry.
> 
> But on a fileserver with 128 GB of ram and a 75 TB filesystem (yes,
> that's likely a dedicated fileserver), we can quite easily justify a
> btree node cache of perhaps 10GB, and on random update workloads the
> journal does need to be that big - otherwise our btree node write size
> goes down and throughput suffers.
> 
>> Why do you keep on being the person who creates all these pointless
>> arguments? Not just with me, btw.
> 
> That's only going to get the biggest eyeroll ever.
> 


