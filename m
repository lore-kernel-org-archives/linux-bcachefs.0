Received: from szxga06-in.huawei.com (szxga06-in.huawei.com [45.249.212.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA7C54314E
	for <linux-bcachefs@vger.kernel.org>; Fri, 19 Apr 2024 07:40:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713512421; cv=none; b=HNt7n/yoHagK83ktai9cM0Lf9AOqVq3qwnTITPKyK/EpjRPoMfyhEl8MMmT8/qrvx15HmG6a9bP3hI78bNDOTuB9fDi0Sc/NetkpEmma2w9dS4JpROmYzIHbRBjWJy2OJl4LZgpJ3krYzPK9e+D3hn+qrvaAP/Jh+Nl3yuKQrZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713512421; c=relaxed/simple;
	bh=RcfaqsUr1RmbGaxf4TCffDuNpyo12D7pyGOEcyPQag0=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=bThnwWVa7KaKdoQarZHcnaG4RMZtVfojRdhokspoadErE830KOmcFFhmf3LfqDoWxRrWI39h/5InEfexMjNbhJtYZXzJZsqP6wIDfVU1NeZUGZ2NParCArQ8V8m0B+3QPfHrYNJs8C1+IMMYROc28Sj0SiAozBwJabQJEnOWpFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.163])
	by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4VLRNh5j1gz1wrJq
	for <linux-bcachefs@vger.kernel.org>; Fri, 19 Apr 2024 15:39:16 +0800 (CST)
Received: from canpemm500009.china.huawei.com (unknown [7.192.105.203])
	by mail.maildlp.com (Postfix) with ESMTPS id 1CF7E180063
	for <linux-bcachefs@vger.kernel.org>; Fri, 19 Apr 2024 15:40:16 +0800 (CST)
Received: from [10.108.234.194] (10.108.234.194) by
 canpemm500009.china.huawei.com (7.192.105.203) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Fri, 19 Apr 2024 15:40:15 +0800
Message-ID: <b6185f2b-c478-4153-bd2e-d83700c03fff@huawei.com>
Date: Fri, 19 Apr 2024 15:40:15 +0800
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: <linux-bcachefs@vger.kernel.org>
From: "wangjianjian (C)" <wangjianjian3@huawei.com>
Subject: subscribe bcachefs
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 canpemm500009.china.huawei.com (7.192.105.203)

subscribe bcachefs
-- 
Regards
