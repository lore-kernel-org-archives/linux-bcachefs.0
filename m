Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C008C76196
	for <linux-bcachefs@archiver.kernel.org>; Mon, 10 Apr 2023 11:51:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229557AbjDJLvV (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Mon, 10 Apr 2023 07:51:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229536AbjDJLvV (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Mon, 10 Apr 2023 07:51:21 -0400
Received: from mr6.vodafonemail.de (mr6.vodafonemail.de [145.253.228.166])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D7334C22
        for <linux-bcachefs@vger.kernel.org>; Mon, 10 Apr 2023 04:51:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arcor.de;
        s=vfde-mb-mr2-21dec; t=1681127477;
        bh=vAR9splMd1ARgEQVzJbjWaUJXV3Ihad7ATiXFivHOaQ=;
        h=Message-ID:Date:User-Agent:From:Subject:To:Content-Language:
         Content-Type:From;
        b=FSzkmhrRm32DQjlF5pMDtV65ZPXBnPjhI0qjBUyJiRFFA60GPRpKIdEcnKWxmVx4F
         FDVA+07wGrVg8mXrtADrUYQHa5tNgRZZKo/1LaekY2SbgrGo299wI0bF6lTQeK1zhV
         S1d0u0Z5izLVVIklxGEClqZ+IvSpoo08M8HLxezk=
Received: from smtp.vodafone.de (unknown [10.0.0.2])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by mr6.vodafonemail.de (Postfix) with ESMTPS id 4Pw6kY5Gp1z1yh2
        for <linux-bcachefs@vger.kernel.org>; Mon, 10 Apr 2023 11:51:17 +0000 (UTC)
Received: from [192.168.1.24] (ip1f12f8d3.dynamic.kabel-deutschland.de [31.18.248.211])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp.vodafone.de (Postfix) with ESMTPSA id 4Pw6kT3y4rz9vr8
        for <linux-bcachefs@vger.kernel.org>; Mon, 10 Apr 2023 11:51:10 +0000 (UTC)
Message-ID: <103b31f5-677c-caf8-f556-4a9c67c37ec4@arcor.de>
Date:   Mon, 10 Apr 2023 13:51:07 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
From:   =?UTF-8?Q?Dr=2e-Ing=2e_Heiko_M=c3=bcnkel?= <heiko.muenkel@arcor.de>
Subject: bcachefs as a caching filesystem
To:     linux-bcachefs@vger.kernel.org
Content-Language: de-DE
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-purgate-type: clean
X-purgate: clean
X-purgate-size: 1489
X-purgate-ID: 155817::1681127473-F67FB4DE-C2D8614A/0/0
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

Hello,

I am in the process of testing bcachefs. I have two partitions 
/dev/nvme0n1p1 and /dev/sde1. The first (internal SSD) should be as 
cache for the second (is an SSD on a USB3 port).

First I created the bcachefs file system with:
   sudo bcachefs format \
        --label=Shotwell-3 /dev/sde1 \
        --label=Shotwell-Cache-1 /dev/nvme0n1p1 \
        --foreground_target /dev/nvme0n1p1 \
        --promote_target /dev/nvme0n1p1 \
--background_target /dev/sde1
and then mount the disks with
  sudo mount -t bcachefs /dev/nvme0n1p1:/dev/sde1 /mnt

This worked fine so far. I then used dd to create a 100GB file on /mnt 
and found, as expected, that the file was written much faster.

Since I occasionally want to use the external disk on another machine, I 
then tried disconnecting the cache from the array.

Since I didn't really find anything in the documentation about this, I 
tried the following command (after the external disk had come to rest 
and thus the 100GB file was presumably also on the disk):
     bcachefs device evacuate /dev/nvme0n1p1

After this command, it took what felt like hours for the external disk 
to come to rest again. Is this normal?

Is this the right command for this case, or do I have to use the command
   bcachefs device offline /dev/nvme0n1p1
to disconnect the cache and
   bcachefs device online /dev/nvme0n1p1
to reconnect?


Thanks for your help,

Heiko






