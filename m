Return-Path: <linux-bcachefs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B989C433F5
	for <linux-bcachefs@archiver.kernel.org>; Sun,  9 Oct 2022 13:03:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230186AbiJINDl (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Sun, 9 Oct 2022 09:03:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230160AbiJINDk (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Sun, 9 Oct 2022 09:03:40 -0400
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80E462D1CC
        for <linux-bcachefs@vger.kernel.org>; Sun,  9 Oct 2022 06:03:35 -0700 (PDT)
Received: by mail-yb1-xb2b.google.com with SMTP id k3so10428476ybk.9
        for <linux-bcachefs@vger.kernel.org>; Sun, 09 Oct 2022 06:03:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Y4gat+9+gEYve+cOQpOIhbcqn+jIfoT9ogA7W+/Cc3c=;
        b=JkH5mLr2CLqnFS+gMDERXoG6vMknzt8GQ9KQr6nZao+mE/XgB+0EajXj/Zq+PA52zq
         7W9mkWXbxhHQDy34LlxvntRxT//6JH1xptcTyh5P+J6GUqcRkiLULtuWTS1wN5YpnUdW
         FBfiPJee7r4vBhlLW/gxoGgXQpPGc3WLJjkyFa/Rd0rtrXwe7ejwVp7h4mHe8SXJ3+FL
         NBnOBmgNae7NiS32lL5mYZsMSiLSo6aA8zX2i93UiTnTkc8FL7nZzk4jsL/Z2wjGa0SB
         PUuYuTOUVxUwiynzBcQLfQzQpqEzAyDufQkMZBnfvzOp284A2zAdL7Jh1smCdMfdhOTS
         Agew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Y4gat+9+gEYve+cOQpOIhbcqn+jIfoT9ogA7W+/Cc3c=;
        b=68tW9UoM+TUDkNbVJf2KqeNPD8LBFsS2xryP+fihDo8VvpTDJ/GlS6qSDE0KLKxQrn
         BNK9E0hZDYPGOBM9UkKbEulEdAQSp18yUEsTp+yn5WoNqM8J3FYuH+9dxnUpPp9zPqun
         4QFZ6C13cx6T+Z/HqudrKND4PTG4DfSSu2UZQ6roAiMWEmd+EBIR7BcOGZDfvLpDMnbk
         ejNPD/gULw09wBOjORgDuXfskcC5lw2nRYlLeg39fURQqtF0j5ymU7d11EXyb5Eu6ufq
         YejZ5/kkqKqShtZG8xQ05i2feZhggbYfM8zpI171I8X+qIgFYIVgDM0AT6TgDJQd0EI3
         pd2w==
X-Gm-Message-State: ACrzQf13a3qy2L8gd2JWMx3QSkjTCJW13RLe9m3xt1/Id3jXAOYM+AGb
        2hEuyu2yTxb5fRPlfI5IhuoxbkJZxwX1Y35gMKtA6Ei9HsU=
X-Google-Smtp-Source: AMsMyM6q7tYRQekDGEB3/yn7iw5S1K/TkUdq7MpFFwqNf/rCJCZPVX703xDLioVAs9xPjy5tEf3HTBNSGvjowHBh5V0=
X-Received: by 2002:a05:6902:726:b0:6be:efc4:c04d with SMTP id
 l6-20020a056902072600b006beefc4c04dmr13476480ybt.168.1665320614128; Sun, 09
 Oct 2022 06:03:34 -0700 (PDT)
MIME-Version: 1.0
From:   Andrea Gelmini <andrea.gelmini@gmail.com>
Date:   Sun, 9 Oct 2022 15:03:18 +0200
Message-ID: <CAK-xaQb8Bk86LOPsJj4RhoncPir9jx4o6DFi1aHt6qO+TLupew@mail.gmail.com>
Subject: Fix example on bcachefs.org
To:     linux-bcachefs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

Hi,
  thanks a lot for your work.

  On homepage
  "--promote-target /dev/sda1"
  must be
  "--promote_target /dev/sda1"

Ciao,
Gelma
