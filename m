Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ED8D23AD;
	Mon, 17 Mar 2025 21:13:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742246006; cv=none; b=CahaGpdFpYSUlbfWrGjLWKd87VXViRj/vct96Eg5BeuzASZwD9Mh1jk19Lnk40JYiv7NaB9Ij1l7RJz/K+khmpNz/M7Gli+/Wtvt705ECMq8+JQSPX6OZcegGq9InfU3v8I9hb8I9SWUA2l4U49CrlJuk+g2HyW6ndaUXhKTaw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742246006; c=relaxed/simple;
	bh=10740IUU4lo2+tJUfVD68yVASYhgP6+rcdzcnGcg3b0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uiRzwEESFdCcGrnTsmxJEUz1GvS8AwiZybTda/aiFyo3tq1T4Vc8acG27NgsgbUwR2K5Bv8o7c70oY+7sPth6YcW7UW9PbSmLlP0jSwOmY7ckjBwf43BmpZjvxeumaK2hItjkWzURoohk87sGB16bbTnUf24P2zN+c6+7eG8FdM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=UpM2Rro7; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="UpM2Rro7"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4ZGnkq03hpzm0jvS;
	Mon, 17 Mar 2025 21:13:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1742246001; x=1744838002; bh=3HdYxa/gIV3N2ZINJDMl39vf
	C+jfzUuFqXvUiOLahek=; b=UpM2Rro7Zh9yaOVF9wodAbyfEeeHvVr2KW3n1fkP
	jevD21XZNc07odNStCnUA/iXcu9P2h1FT09078TEh3BOjyWUP12AI6r5naOaLbc0
	/yQDhhJFfkAo/u0sEZWKnMj+xhgSK6+co1ieCJb+EXxgzQ3D6FdcjXCuWSP2Wsak
	3Ct4nxZFfcbmMyiQYTf/e9SLKOu9bkZC1nn4be3gcjkPv/a8e7DRnLJ5MydgM0Z0
	mGoeSnR0n9v0JEYvJDlV8hq4hViMgbNMAaUyS/8zZautkHV5f1EGtRoi3bwuZIf1
	PjrM6wUfAXIfl5GzOimL7XVKnJwjIi1dEpnXeNLN2YxYtQ==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id qT22mN6M46Ek; Mon, 17 Mar 2025 21:13:21 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4ZGnkh36L2zm0ysg;
	Mon, 17 Mar 2025 21:13:15 +0000 (UTC)
Message-ID: <566e4f59-4aaa-4d8e-b61f-b27cf79c1201@acm.org>
Date: Mon, 17 Mar 2025 14:13:14 -0700
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 13/14] block: Allow REQ_FUA|REQ_READ
To: Keith Busch <kbusch@kernel.org>,
 Kent Overstreet <kent.overstreet@linux.dev>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
 Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>,
 linux-bcachefs@vger.kernel.org, linux-block@vger.kernel.org,
 Linus Torvalds <torvalds@linux-foundation.org>
References: <fy5lq7bxyr64f7oiypo343s57nujafjue2bcl72ovwszbzasxk@k6jhr6asqtmx>
 <Z9e6dFm_qtW29sVe@infradead.org>
 <fhhgjnhmk72vpruhgftwq3lzfmylbhn6cuajj6saikee2zuqjp@54yfyxu35yiz>
 <Z9guJ2VxvqAmm9o9@kbusch-mbp.dhcp.thefacebook.com>
 <yq1msdjg23p.fsf@ca-mkp.ca.oracle.com>
 <qhc7tpttpt57meqqyxrfuvvfaqg7hgrpivtwa5yxkvv22ubyia@ga3scmjr5kti>
 <yq1bjtzfyen.fsf@ca-mkp.ca.oracle.com>
 <zjwvemsjlshzm5zes7jznmhchvf2erebmuil4ssnkax3lwpw3a@5gnzbjlta36f>
 <Z9h25wvi0VQOaGh2@kbusch-mbp.dhcp.thefacebook.com>
 <ysvt4npanz4qfoxm5cv627cq2ommq6rxpka6pkvl3l2crcatmc@ic7tn5tt7aw4>
 <Z9iIa770ySTgKgp0@kbusch-mbp.dhcp.thefacebook.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <Z9iIa770ySTgKgp0@kbusch-mbp.dhcp.thefacebook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/17/25 1:39 PM, Keith Busch wrote:
> On Mon, Mar 17, 2025 at 03:40:10PM -0400, Kent Overstreet wrote:
>> If, OTOH, this is just something that hasn't come up before - the
>> language in the spec is already there, so once code is out there with
>> enough users and a demonstrated use case then it might be a pretty
>> simple nudge - "shoot down this range of the cache, don't just flush it"
>> is a pretty simple code change, as far as these things go.
> 
> So you're telling me you've never written SSD firmware then waited for
> the manufacturer to release it to your users? Yes, I jest, and maybe
> YMMV; but relying on that process is putting your destiny in the wrong
> hands.

As far as I know in the Linux kernel we only support storage device 
behavior that has been standardized and also workarounds for bugs. I'm
not sure we should support behavior in the Linux kernel that deviates
from existing standards and that also deviates from longstanding and
well-established conventions.

Bart.
