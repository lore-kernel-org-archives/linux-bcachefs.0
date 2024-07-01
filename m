Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8912F2C80
	for <linux-bcachefs@vger.kernel.org>; Mon,  1 Jul 2024 03:16:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719803805; cv=none; b=EinF07OrxQTP9C2car4RoAWz8o0JfNqwftYNz9C82Qixytoxa+5EhPa+cMhq0h3zAPoQ8haWjUwWU17Tu2xX97buJp++WQpKrxGxf5YzU8l1+k7deGJofV5mfArnfYGkjR3LBf8gw9TUql+PL6MkQ6RL+t7Kt+dJmGatUZEv1Gg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719803805; c=relaxed/simple;
	bh=+S7tJRkQK/CkFu8GUPmkSryFc2Zwu5E/aE0nbvEqB/Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DtjN0fCroEWXw5UHgu7MtK2gikocs1dRF3jrFJUqq6kcoYy6Wcs+QYY1kaRdwounm9piXiGABSuU2ZI7jCGm6Zi6ryB62pON8Iw1HRNyKQHlKFHmh/iMmbVgpoV+CdNTEib7yLl1Qtkd2dePdERo+GV2Iw1ejniV8qK8lvM2lCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DTU7587S; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DTU7587S"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1719803803;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=viQG/1ciLB7oJ/0omugD7kTmJcNapKZKS5EL54NXd2M=;
	b=DTU7587S6RrlLJea78UT49qCTpsZA6epC9ZHaGrucOLL0AHVT33FLr6FvygZ2IAe6muMgy
	5T65I39AYy2ldkeZc6r8WCyFTu7qtgWcBubDJoGvTjdEv6QletZ0JaUJrTR/7U2LGUK6iF
	VQaXnv0GVDXAmX2DUyCv7RcjKCX13tA=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-205-A_Ssgs25OdajJj1d0ITndg-1; Sun,
 30 Jun 2024 23:16:40 -0400
X-MC-Unique: A_Ssgs25OdajJj1d0ITndg-1
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 036C519560AD;
	Mon,  1 Jul 2024 03:16:39 +0000 (UTC)
Received: from [10.22.8.67] (unknown [10.22.8.67])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 6466F3000218;
	Mon,  1 Jul 2024 03:16:37 +0000 (UTC)
Message-ID: <62c553f2-2fb3-4b83-86ae-5b038941cdbb@redhat.com>
Date: Sun, 30 Jun 2024 23:16:36 -0400
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] lockdep: lockdep_set_notrack_class()
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-kernel@vger.kernel.org, linux-bcachefs@vger.kernel.org,
 Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
 Will Deacon <will@kernel.org>, Boqun Feng <boqun.feng@gmail.com>
References: <20240630051037.2785156-1-kent.overstreet@linux.dev>
 <016f2bd0-a192-4ec5-9c4b-d48e8e001cd6@redhat.com>
 <uvf4ilncakodvwmu6kbzs4lrxgeegtanhyhsk52xj7foil65jm@p54wibff6bgc>
Content-Language: en-US
From: Waiman Long <longman@redhat.com>
In-Reply-To: <uvf4ilncakodvwmu6kbzs4lrxgeegtanhyhsk52xj7foil65jm@p54wibff6bgc>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4


On 6/30/24 20:10, Kent Overstreet wrote:
> On Sun, Jun 30, 2024 at 06:08:21PM GMT, Waiman Long wrote:
>> On 6/30/24 01:10, Kent Overstreet wrote:
>>> Add a new helper to disable lockdep tracking entirely for a given class.
>>>
>>> This is needed for bcachefs, which takes too many btree node locks for
>>> lockdep to track. Instead, we have a single lockdep_map for "btree_trans
>>> has any btree nodes locked", which makes more since given that we have
>>> centralized lock management and a cycle detector.
>> Could you explain a bit more what the current novalidate_class is lacking
>> WRT to the bcachefs lock? Is it excessive performance overhead or some bogus
>> lockdep warning?
> novalidate just switches off checking of lock ordering, but the fact
> that the locks are held is still tracked.
>
> bcachefs takes more btree node locks than lockdep can track, so I'm
> switching to a single lockdep map for "this btree_trans has any btree
> nodes locked" instead.

I asked because you are adding a new special class that is similar to 
no_validate in some way but also a bit different. So we need to document 
what each of these special classes are for to avoid confusion.

Cheers,
Longman

