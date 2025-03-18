Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D49720B807;
	Tue, 18 Mar 2025 17:49:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742320179; cv=none; b=m1X7FVJgoWEruVzoJkyst3nH8fwDC/Ihr7OdSYG5ES6Lxf1XLQmEzcrQrJf8VbHxzjIagKDzzBvms63J4hKdEZHrJjKqNsT8W1W7rzz8YNucLfQLFAcwyXGxPJlsQZJBrP4L1k1m9+Yj12dh8bt+spMG6XGVKsua2731lQ6HyG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742320179; c=relaxed/simple;
	bh=IYsa6MGKR7XUOvqEKeGyQAa4P8dV+JrfgleJujHMbJ4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=elekNDLJ7Fh3/cJS8e+xujpwnySM6a9sZyxWtjuSm/MPid2nWA5fX9vuP3j5Ogx5sRvO4I0zrNLFlcBSIWJpvk/H74Q/lLSVaoyeBKBZ5yxDt9Pj9FHNECoGSeri+A3XaSIy3j/+v9/rA+CI30xknaCrv/LZpsi10y4ZRnnkjdg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=RV6I4dOB; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="RV6I4dOB"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4ZHK9D2pSmzlyw8n;
	Tue, 18 Mar 2025 17:49:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1742320174; x=1744912175; bh=IYsa6MGKR7XUOvqEKeGyQAa4
	P8dV+JrfgleJujHMbJ4=; b=RV6I4dOBT6YQ48WBNQGHZnwn5MtioVsulSxsIG/U
	fW7xH4A5h57Kr+Y4EGhmhHTewnarNQzqrQ1dBuE3ArwYIipwJYsfqFqJMj75bWgc
	NpjwAxTPj4bMeui/I20+6tRDh9lLEXhZtYzdRi2FLUBQov0aBui1Gae/zfptRt7Z
	3xzEdwfJ7trgf564BZNg8FGcqstLxb361xHrnrbhb9mjVEXWgcU+HFo+RjVrk41j
	er+dUOFIlys1t/TcGg+gTAnmpBbqRB6BCh1EiwfsHUdR/j4PHemrUmnBKdqjAnQF
	0qnWQvIeqWnmaOFnwh/VH4uQOlesPagoTsxDm71xgyLjiQ==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id iY5CP80lKQ7U; Tue, 18 Mar 2025 17:49:34 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4ZHK930mJnzlyw85;
	Tue, 18 Mar 2025 17:49:25 +0000 (UTC)
Message-ID: <18b03fe9-1f57-48ac-92e3-308d27c5d144@acm.org>
Date: Tue, 18 Mar 2025 10:49:25 -0700
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 13/14] block: Allow REQ_FUA|REQ_READ
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Keith Busch <kbusch@kernel.org>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>,
 linux-bcachefs@vger.kernel.org, linux-block@vger.kernel.org,
 Linus Torvalds <torvalds@linux-foundation.org>
References: <fhhgjnhmk72vpruhgftwq3lzfmylbhn6cuajj6saikee2zuqjp@54yfyxu35yiz>
 <Z9guJ2VxvqAmm9o9@kbusch-mbp.dhcp.thefacebook.com>
 <yq1msdjg23p.fsf@ca-mkp.ca.oracle.com>
 <qhc7tpttpt57meqqyxrfuvvfaqg7hgrpivtwa5yxkvv22ubyia@ga3scmjr5kti>
 <yq1bjtzfyen.fsf@ca-mkp.ca.oracle.com>
 <zjwvemsjlshzm5zes7jznmhchvf2erebmuil4ssnkax3lwpw3a@5gnzbjlta36f>
 <Z9h25wvi0VQOaGh2@kbusch-mbp.dhcp.thefacebook.com>
 <ysvt4npanz4qfoxm5cv627cq2ommq6rxpka6pkvl3l2crcatmc@ic7tn5tt7aw4>
 <Z9iIa770ySTgKgp0@kbusch-mbp.dhcp.thefacebook.com>
 <566e4f59-4aaa-4d8e-b61f-b27cf79c1201@acm.org>
 <4mqi7e74ji7j3pzfdhfncz2yz3vvvvb6jivtzry4pmljgygcg5@hd5pv2lddzeq>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <4mqi7e74ji7j3pzfdhfncz2yz3vvvvb6jivtzry4pmljgygcg5@hd5pv2lddzeq>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/17/25 6:06 PM, Kent Overstreet wrote:
> What bcachefs is doing is entirely in line with the behaviour the
> standard states.

I do not agree with the above.

Kent, do you plan to attend the LSF/MM/BPF summit next week? I'm
wondering whether allowing REQ_FUA|REQ_READ would be a good topic
for that summit.

Bart.
