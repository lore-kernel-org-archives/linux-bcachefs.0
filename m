Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A96C198E8F
	for <linux-bcachefs@vger.kernel.org>; Mon, 17 Jun 2024 20:17:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718655458; cv=none; b=TBh826KYZwIEZS7w69b+0TwulOUzPm6dA6JA7o13PjzcOfzt5ffjeoTpUnwMwDXY2kYhy1HgCJDumAVGHb1KhBOCWB0pJ8lPrhyRZ6hlBegZVm7yZBdcA4sKnQA8F7TnhRpGDoCjXa2QLLcgsdX9wX5AULkzce0GbAg82OsojLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718655458; c=relaxed/simple;
	bh=sMcHsxJVaoRTcqfJ+9L3LPW1CEuAARR8ZnOoFQiQI/A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Y5xPa5S7J3Uvax5kqncJUXCZq5FTp443smT6Jj2u7IiK8s6VTF9eIeVfyr9Pni6bncooekZ+d8JOAnzHVNoICT574LGPgJta9rZtp+bEM3GuaTLiDltCTJvxF4b6XpaQXyZpjh7neAQ4uNuQeaxf+cobdTudDgp2NeC7ja7ige0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=JiBBN/Iv; arc=none smtp.client-ip=91.218.175.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="JiBBN/Iv"
X-Envelope-To: syzbot+df3bf3f088dcaa728857@syzkaller.appspotmail.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1718655453;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=sMcHsxJVaoRTcqfJ+9L3LPW1CEuAARR8ZnOoFQiQI/A=;
	b=JiBBN/Iv/CmVvZsmywOgOIK9HJU/CNoe4Er6VJs2B5dQp9OriErR18wtOHbAY+8JvRARSJ
	8OUr4yNu15nnyDpE/txQ6Ahc7M0rOVehVqlf0O4wyb/AVq51TcvFBu+sR1ChG+ybd2bQsq
	OjxTLD9hFdSCiyj50/PYq/YXsXjfcwQ=
X-Envelope-To: bfoster@redhat.com
X-Envelope-To: linux-bcachefs@vger.kernel.org
X-Envelope-To: linux-kernel@vger.kernel.org
X-Envelope-To: syzkaller-bugs@googlegroups.com
Date: Mon, 17 Jun 2024 16:17:29 -0400
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: syzbot <syzbot+df3bf3f088dcaa728857@syzkaller.appspotmail.com>
Cc: bfoster@redhat.com, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [bcachefs?] kernel BUG in bch2_lru_change
Message-ID: <lysbmilibifncvckcfz2jzhkytqp4yzpyi3iiiv2rgbsiqy5hx@hjypw2inze4i>
References: <000000000000515313061a401ea1@google.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000000000000515313061a401ea1@google.com>
X-Migadu-Flow: FLOW_OUT

#syz fix: Guard against overflowing LRU_TIME_BITS
