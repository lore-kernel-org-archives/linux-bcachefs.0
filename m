Received: from m16.mail.126.com (m16.mail.126.com [220.197.31.6])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E6081F706E;
	Tue,  8 Oct 2024 08:12:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728375170; cv=none; b=hjQi8dwuCnQNflP8qrB+dGfYAmyPIFDTqEfuAXDbgDdRsGhqm5eX45mRqtHqC0NZdeqcXKlDZajXeuUtKe9+eSRy8sucz3k+pQK3CRwbmtEnswpgBK02gb4jLjBqbMc4STVJA16VNPaymb1rTV29L8lNgtmn00ff0EHb1DdPi7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728375170; c=relaxed/simple;
	bh=WFTF3H0F9YPg5OU52MdbUO9DraTwAMYxffdLOXNmE0k=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=rtBM567hUpsqG4cIC1nBvQcMasxeLLp4THohKakKPhENPC2mft7GeCqhtgnzRxx/BNGJ1r5zVuR0Ae9/pEqrdE1tam4iWwPz/Ce6ElnKnmq/sleju8jSff8YVs95SAKUPsotOtAtetsO3uHSHfDqWepDJ7mAj/IqYkrMf2oW6vs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=126.com; spf=pass smtp.mailfrom=126.com; dkim=pass (1024-bit key) header.d=126.com header.i=@126.com header.b=Nz7zrli8; arc=none smtp.client-ip=220.197.31.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=126.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=126.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=126.com header.i=@126.com header.b="Nz7zrli8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
	s=s110527; h=Message-ID:Date:MIME-Version:From:Subject:
	Content-Type; bh=WFTF3H0F9YPg5OU52MdbUO9DraTwAMYxffdLOXNmE0k=;
	b=Nz7zrli8uZmXyoZEPF1eYwrZCNEmcC6jDvWHRtQIqtIRl0EoRVhN57AeGIaVga
	uxa0nsJSlhHwQ3YcSLRUXrHx5zXT9/E7wDo1DQG7VKrq4bOAUotKJrQwNYBHXrAo
	bKyBMd9xrycFcKxep5mhjOa/3KCXLZW+her7iW/J7XNZ0=
Received: from [192.168.109.86] (unknown [1.198.30.91])
	by gzga-smtp-mtada-g1-4 (Coremail) with SMTP id _____wD3vwJm6QRnilLkAQ--.37318S2;
	Tue, 08 Oct 2024 16:12:23 +0800 (CST)
Message-ID: <6668bb9a-4775-4549-b24a-54b1f386374e@126.com>
Date: Tue, 8 Oct 2024 16:12:22 +0800
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Zhao Mengmeng <zhaomzhao@126.com>
Subject: Re: [syzbot] [bcachefs?] UBSAN: shift-out-of-bounds in
 bch2_stripe_to_text
To: syzbot+f8c98a50c323635be65d@syzkaller.appspotmail.com
Cc: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org,
 linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <66f4dcd2.050a0220.211276.003a.GAE@google.com>
In-Reply-To: <66f4dcd2.050a0220.211276.003a.GAE@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:_____wD3vwJm6QRnilLkAQ--.37318S2
X-Coremail-Antispam: 1Uf129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73
	VFW2AGmfu7bjvjm3AaLaJ3UbIYCTnIWIevJa73UjIFyTuYvjxUe_-PDUUUU
X-CM-SenderInfo: 52kd0zp2kd0qqrswhudrp/1tbi6Blyd2cE52wh5QAAsY

#syz test: git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git 1ec6d097897a

